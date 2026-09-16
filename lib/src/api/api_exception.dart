/// Stable error codes the v1 contract can return. Unknown codes decode to
/// [FeaturelyErrorCode.unknown] and are treated as generic failures.
enum FeaturelyErrorCode {
  /// 401 — missing, malformed, unknown, or revoked key.
  invalidApiKey('invalid_api_key'),

  /// 400 — missing or malformed `X-Featurely-Device-Id`.
  invalidDeviceId('invalid_device_id'),

  /// 400 — title missing or not 1–60 characters after trimming.
  invalidTitle('invalid_title'),

  /// 400 — description missing or not 1–10 000 characters after trimming.
  invalidDescription('invalid_description'),

  /// 400 — `type` is not `feature` or `bug`.
  invalidType('invalid_type'),

  /// 400 — `email` was supplied but is not a valid address.
  invalidEmail('invalid_email'),

  /// 400 — comment body not 1–5 000 characters after trimming.
  invalidComment('invalid_comment'),

  /// 400 — `userId` not 1–128 characters after trimming.
  invalidUserId('invalid_user_id'),

  /// 400 — cursor malformed, forged, or from a different sort.
  invalidCursor('invalid_cursor'),

  /// 400 — the screenshot is not PNG/JPEG/WebP by magic bytes.
  attachmentNotImage('attachment_not_image'),

  /// 400 — the screenshot exceeds the instance's upload limit.
  attachmentTooLarge('attachment_too_large'),

  /// 400 — chat message not 1–4 000 characters after trimming, or its
  /// `clientMessageId` is not a UUID.
  invalidMessage('invalid_message'),

  /// 403 — the project has commenting turned off.
  commentsDisabled('comments_disabled'),

  /// 404 — no such item for this key (any of the contract's cases).
  notFound('not_found'),

  /// 404 — the chat conversation does not exist (dashboard-facing; listed
  /// for completeness).
  conversationNotFound('conversation_not_found'),

  /// 429 — a rate limit was exceeded; honor `retry-after`.
  rateLimited('rate_limited'),

  /// 500 — server fault, retryable with backoff.
  internalError('internal_error'),

  /// Any code this SDK build doesn't know (forward-compatible).
  unknown('unknown');

  const FeaturelyErrorCode(this.wire);

  /// The wire value of the code.
  final String wire;

  /// Decodes a wire code, mapping unrecognized values to [unknown].
  static FeaturelyErrorCode decode(String? code) => values.firstWhere(
        (value) => value.wire == code,
        orElse: () => unknown,
      );
}

/// An error response from the API (`{error: {code, message}}`).
///
/// The server `message` is developer-facing English and is deliberately not
/// carried here — the SDK branches on [code] only and shows its own
/// localized copy.
class FeaturelyApiException implements Exception {
  /// Creates an exception for a decoded error response.
  FeaturelyApiException(this.code, this.statusCode, {this.retryAfter});

  /// The stable error code (or [FeaturelyErrorCode.unknown]).
  final FeaturelyErrorCode code;

  /// The HTTP status of the response.
  final int statusCode;

  /// Parsed `retry-after` delay for 429 responses.
  final Duration? retryAfter;

  @override
  String toString() =>
      'FeaturelyApiException(${code.wire}, HTTP $statusCode)';
}

/// A transport-level failure (no HTTP response was received).
class FeaturelyNetworkException implements Exception {
  /// Creates a transport failure marker. The [cause] is kept for debugging
  /// and never contains request headers.
  FeaturelyNetworkException([this.cause]);

  /// The underlying error, if any.
  final Object? cause;

  @override
  String toString() => 'FeaturelyNetworkException($cause)';
}
