import 'package:featurely/src/api/api_client.dart';
import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/core.dart';
import 'package:featurely/src/identity/identity_store.dart';
import 'package:featurely/src/l10n/locale_resolution.dart';
import 'package:featurely/src/metadata.dart';
import 'package:featurely/src/options.dart';
import 'package:featurely/src/theme.dart';
import 'package:featurely/src/ui/sheet.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A fake API client with per-endpoint handler hooks.
class FakeApi extends FeaturelyApiClient {
  FakeApi()
      : super(
          baseUrl: 'https://feedback.example.com',
          apiKey: 'fk_fake',
          environment: 'sandbox',
          deviceIdProvider: () async => 'u_fake_device_1234567890',
          httpClient: MockClient(
            (request) async => http.Response('unexpected', 500),
          ),
        );

  SdkConfig config = const SdkConfig(
    projectName: 'Pocket Bartender',
    commentingEnabled: true,
    titleMax: 60,
    descriptionMax: 10000,
    commentMax: 5000,
    attachmentMaxBytes: 5242880,
  );

  Future<Page<FeedbackItem>> Function(
      FeedbackSort sort, FeedbackStatus? status, String? cursor, int? limit)?
      onList;
  Future<FeedbackDetail> Function(String id)? onGetFeedback;
  Future<VoteResult> Function(String id)? onVote;
  Future<VoteResult> Function(String id)? onUnvote;
  Future<FeedbackComment> Function(String id, String body)? onAddComment;
  Future<FeedbackItem> Function()? onSubmit;

  /// The metadata map of the most recent [submitFeedback] call.
  Map<String, String>? lastSubmissionMetadata;

  @override
  Future<SdkConfig> getConfig() async => config;

  @override
  Future<Page<FeedbackItem>> listFeedback({
    FeedbackSort sort = FeedbackSort.votes,
    FeedbackStatus? status,
    String? cursor,
    int? limit,
  }) {
    final handler = onList;
    if (handler == null) {
      return Future.value(const Page(items: <FeedbackItem>[], nextCursor: null));
    }
    return handler(sort, status, cursor, limit);
  }

  @override
  Future<FeedbackDetail> getFeedback(String id) =>
      onGetFeedback!.call(id);

  @override
  Future<VoteResult> vote(String id) => onVote!.call(id);

  @override
  Future<VoteResult> unvote(String id) => onUnvote!.call(id);

  @override
  Future<FeedbackComment> addComment(String id, String body) =>
      onAddComment!.call(id, body);

  @override
  Future<FeedbackItem> submitFeedback({
    required String title,
    required String description,
    required FeedbackType type,
    String? email,
    Map<String, String> metadata = const {},
    screenshotBytes,
    String? screenshotContentType,
  }) {
    lastSubmissionMetadata = metadata;
    return onSubmit!.call();
  }
}

/// A feedback item fixture.
FeedbackItem makeItem({
  String id = 'item-1',
  String title = 'Offline mode for saved articles',
  int votes = 12,
  bool voted = false,
  FeedbackStatus status = FeedbackStatus.open,
  int comments = 3,
  bool hasAttachment = false,
}) =>
    FeedbackItem(
      id: id,
      title: title,
      description: 'A longer description of the request.',
      type: FeedbackType.feature,
      status: status,
      votes: votes,
      viewerHasVoted: voted,
      commentCount: comments,
      hasAttachment: hasAttachment,
      createdAt: DateTime.utc(2026, 7, 14, 8, 21),
    );

/// Builds a [FeaturelyCore] over [api].
FeaturelyCore makeCore(
  FakeApi api, {
  FeaturelyEnvironment environment = FeaturelyEnvironment.sandbox,
  Locale? locale,
  bool seedConfig = true,
}) {
  final core = FeaturelyCore(
    options: FeaturelyOptions(
      baseUrl: 'https://feedback.example.com',
      apiKey: 'fk_fake',
      environment: environment,
      locale: locale,
    ),
    identity: IdentityStore(),
    api: api,
    metadata: DeviceMetadata(override: const {
      'appVersion': '1.0.0',
      'appBuild': '1',
      'osVersion': 'TestOS 1',
      'deviceModel': 'Test Device',
      'deviceLocale': 'en-US',
    }),
  );
  if (seedConfig) core.cachedConfig = api.config;
  return core;
}

/// Pumps the full sheet inside a host `MaterialApp`.
Future<void> pumpSheet(
  WidgetTester tester,
  FeaturelyCore core, {
  FeaturelyTheme? theme,
  Size surface = const Size(390, 844),
}) async {
  await tester.binding.setSurfaceSize(surface);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => FeaturelySheet(
          core: core,
          theme: FeaturelyThemeData.resolve(context, theme),
          localeTag: resolveLocaleTag(core.options.locale?.toLanguageTag()),
          platform: TargetPlatform.android,
        ),
      ),
    ),
  );
  await tester.pump();
}
