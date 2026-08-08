import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'api_exception.dart';
import 'models.dart';

/// HTTP client for the frozen `/api/v1` contract.
///
/// Every request carries `Authorization: Bearer <key>` and
/// `X-Featurely-Device-Id`. Reads retry transport errors and 5xx with
/// backoff (max 2 retries); non-429 4xx are never retried unchanged; 429 is
/// surfaced with its parsed `retry-after` and never auto-retried. The API
/// key is never logged and never appears in exception text.
class FeaturelyApiClient {
  /// Creates a client. [deviceIdProvider] is awaited per request so identity
  /// rotation applies immediately. [readRetryDelay] exists for tests.
  FeaturelyApiClient({
    required String baseUrl,
    required String apiKey,
    required Future<String> Function() deviceIdProvider,
    http.Client? httpClient,
    Duration Function(int attempt)? readRetryDelay,
  })  : _baseUrl = baseUrl,
        _apiKey = apiKey,
        _deviceIdProvider = deviceIdProvider,
        _http = httpClient ?? http.Client(),
        _readRetryDelay = readRetryDelay ??
            ((attempt) => Duration(milliseconds: 400 * (1 << attempt)));

  final String _baseUrl;
  final String _apiKey;
  final Future<String> Function() _deviceIdProvider;
  final http.Client _http;
  final Duration Function(int attempt) _readRetryDelay;

  static const int _maxReadRetries = 2;

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$_baseUrl/api/v1$path').replace(
        queryParameters: (query == null || query.isEmpty) ? null : query,
      );

  /// Both auth headers, for use by `Image.network` on the attachment
  /// endpoint as well as every request this client makes.
  Future<Map<String, String>> authHeaders() async => {
        'Authorization': 'Bearer $_apiKey',
        'X-Featurely-Device-Id': await _deviceIdProvider(),
      };

  /// The attachment URL for [id]; fetch only when `hasAttachment` is true.
  String attachmentUrl(String id) => '$_baseUrl/api/v1/feedback/$id/attachment';

  /// `GET /feedback` — one page of the list.
  Future<Page<FeedbackItem>> listFeedback({
    FeedbackSort sort = FeedbackSort.votes,
    FeedbackStatus? status,
    String? cursor,
    int? limit,
  }) async {
    final json = await _getJson('/feedback', {
      'sort': sort.wire,
      if (status != null) 'status': status.wire,
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': '$limit',
    });
    final items = ((json['items'] as List<dynamic>?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(FeedbackItem.fromJson)
        .toList();
    return Page(items: items, nextCursor: json['nextCursor'] as String?);
  }

  /// `GET /feedback/:id` — detail with comments.
  Future<FeedbackDetail> getFeedback(String id) async =>
      FeedbackDetail.fromJson(await _getJson('/feedback/$id'));

  /// `GET /config` — per-project configuration.
  Future<SdkConfig> getConfig() async =>
      SdkConfig.fromJson(await _getJson('/config'));

  /// `POST /feedback/:id/vote` — idempotent vote.
  Future<VoteResult> vote(String id) async => VoteResult.fromJson(
      await _sendJson('POST', '/feedback/$id/vote', expect: 200));

  /// `DELETE /feedback/:id/vote` — idempotent unvote.
  Future<VoteResult> unvote(String id) async => VoteResult.fromJson(
      await _sendJson('DELETE', '/feedback/$id/vote', expect: 200));

  /// `POST /feedback/:id/comments` — add a public comment.
  Future<FeedbackComment> addComment(String id, String body) async =>
      FeedbackComment.fromJson(await _sendJson(
        'POST',
        '/feedback/$id/comments',
        body: {'body': body},
        expect: 201,
      ));

  /// `POST /identify` — link the device to an external user. Idempotent.
  Future<void> identify(String userId) async =>
      _sendJson('POST', '/identify', body: {'userId': userId}, expect: 204);

  /// `DELETE /identify` — the logout signal (a server-side no-op; the SDK
  /// completes logout by rotating its device ID).
  Future<void> unidentify() async =>
      _sendJson('DELETE', '/identify', expect: 204);

  /// `POST /feedback` — multipart submission. Never auto-retried: a `201`
  /// must never be resubmitted.
  Future<FeedbackItem> submitFeedback({
    required String title,
    required String description,
    required FeedbackType type,
    String? email,
    Map<String, String> metadata = const {},
    Uint8List? screenshotBytes,
    String? screenshotContentType,
  }) async {
    final request = http.MultipartRequest('POST', _uri('/feedback'));
    request.headers.addAll(await authHeaders());
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['type'] = type.wire;
    if (email != null && email.isNotEmpty) request.fields['email'] = email;
    request.fields.addAll(metadata);
    if (screenshotBytes != null) {
      final contentType = screenshotContentType ?? 'image/png';
      request.files.add(http.MultipartFile.fromBytes(
        'screenshot',
        screenshotBytes,
        filename: 'screenshot.${contentType.split('/').last}',
        contentType: MediaType.parse(contentType),
      ));
    }
    final http.Response response;
    try {
      response = await http.Response.fromStream(await _http.send(request));
    } on FeaturelyApiException {
      rethrow;
    } catch (error) {
      throw FeaturelyNetworkException(error);
    }
    if (response.statusCode == 201) {
      return FeedbackItem.fromJson(_decodeMap(response.body));
    }
    throw _errorFor(response);
  }

  /// Closes the underlying HTTP client.
  void dispose() => _http.close();

  Future<Map<String, dynamic>> _getJson(
    String path, [
    Map<String, String>? query,
  ]) async {
    final uri = _uri(path, query);
    for (var attempt = 0;; attempt++) {
      http.Response response;
      try {
        response = await _http.get(uri, headers: await authHeaders());
      } catch (error) {
        if (attempt < _maxReadRetries) {
          await Future<void>.delayed(_readRetryDelay(attempt));
          continue;
        }
        throw FeaturelyNetworkException(error);
      }
      if (response.statusCode == 200) return _decodeMap(response.body);
      if (response.statusCode >= 500 && attempt < _maxReadRetries) {
        await Future<void>.delayed(_readRetryDelay(attempt));
        continue;
      }
      throw _errorFor(response);
    }
  }

  Future<Map<String, dynamic>> _sendJson(
    String method,
    String path, {
    Map<String, Object?>? body,
    required int expect,
  }) async {
    final headers = await authHeaders();
    final uri = _uri(path);
    http.Response response;
    try {
      final request = http.Request(method, uri)..headers.addAll(headers);
      if (body != null) {
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(body);
      }
      response = await http.Response.fromStream(await _http.send(request));
    } catch (error) {
      throw FeaturelyNetworkException(error);
    }
    if (response.statusCode == expect) {
      return response.body.isEmpty
          ? const <String, dynamic>{}
          : _decodeMap(response.body);
    }
    throw _errorFor(response);
  }

  static Map<String, dynamic> _decodeMap(String body) {
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }

  static FeaturelyApiException _errorFor(http.Response response) {
    FeaturelyErrorCode code;
    try {
      final decoded = _decodeMap(response.body);
      final error = decoded['error'] as Map<String, dynamic>?;
      code = FeaturelyErrorCode.decode(error?['code'] as String?);
    } catch (_) {
      code = FeaturelyErrorCode.unknown;
    }
    Duration? retryAfter;
    if (response.statusCode == 429) {
      final seconds = int.tryParse(response.headers['retry-after'] ?? '');
      retryAfter = Duration(seconds: seconds ?? 30);
      if (code == FeaturelyErrorCode.unknown) {
        code = FeaturelyErrorCode.rateLimited;
      }
    }
    return FeaturelyApiException(
      code,
      response.statusCode,
      retryAfter: retryAfter,
    );
  }
}
