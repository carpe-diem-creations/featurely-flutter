import 'package:featurely/src/api/api_exception.dart';
import 'package:featurely/src/api/models.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

FeedbackDetail detailWith(List<FeedbackComment> comments) => FeedbackDetail(
      item: makeItem(voted: true, votes: 149, status: FeedbackStatus.planned),
      comments: comments,
    );

FeedbackComment comment(String id, CommentAuthor author, String body) =>
    FeedbackComment(
      id: id,
      author: author,
      body: body,
      createdAt: DateTime.utc(2026, 8, 1),
    );

Future<void> openDetail(WidgetTester tester, FakeApi api) async {
  api.onList = (sort, status, cursor, limit) async =>
      Page(items: [makeItem()], nextCursor: null);
  await pumpSheet(tester, makeCore(api));
  await tester.pump();
  await tester.tap(find.text('Offline mode for saved articles'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('renders Anonymous label and accent Team badge', (tester) async {
    final api = FakeApi();
    api.onGetFeedback = (id) async => detailWith([
          comment('c1', CommentAuthor.anonymous, 'Same here on a Pixel 8.'),
          comment('c2', CommentAuthor.team, 'Fix is in the next build.'),
        ]);
    await openDetail(tester, api);

    expect(find.text('Anonymous'), findsOneWidget);
    expect(find.text('Team'), findsOneWidget);
    expect(find.text('Same here on a Pixel 8.'), findsOneWidget);
    expect(find.text('Fix is in the next build.'), findsOneWidget);
    // Voted state on the big vote button.
    expect(find.textContaining('149'), findsOneWidget);
  });

  testWidgets('composer hidden when commenting is disabled in config',
      (tester) async {
    final api = FakeApi();
    api.config = const SdkConfig(
      projectName: 'Pocket Bartender',
      commentingEnabled: false,
      titleMax: 60,
      descriptionMax: 10000,
      commentMax: 5000,
      attachmentMaxBytes: 5242880,
    );
    api.onGetFeedback = (id) async => detailWith([]);
    await openDetail(tester, api);

    expect(find.widgetWithText(TextField, 'Add a comment…'), findsNothing);
  });

  testWidgets('403 comments_disabled hides the composer and shows the notice',
      (tester) async {
    final api = FakeApi();
    api.onGetFeedback = (id) async => detailWith([]);
    api.onAddComment = (id, body) async =>
        throw FeaturelyApiException(FeaturelyErrorCode.commentsDisabled, 403);
    await openDetail(tester, api);

    final composer = find.widgetWithText(TextField, 'Add a comment…');
    expect(composer, findsOneWidget);
    await tester.enterText(composer, 'Can I comment?');
    await tester.tap(find.bySemanticsLabel('Send'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Add a comment…'), findsNothing);
    expect(find.text('Commenting has been turned off.'), findsOneWidget);
  });

  testWidgets('a sent comment appears optimistically then confirms',
      (tester) async {
    final api = FakeApi();
    api.onGetFeedback = (id) async => detailWith([]);
    api.onAddComment = (id, body) async =>
        comment('server-1', CommentAuthor.anonymous, body);
    await openDetail(tester, api);

    await tester.enterText(
        find.widgetWithText(TextField, 'Add a comment…'), 'A new comment');
    await tester.tap(find.bySemanticsLabel('Send'));
    await tester.pumpAndSettle();
    expect(find.text('A new comment'), findsOneWidget);
  });

  testWidgets('comment composer enforces commentMax from config',
      (tester) async {
    final api = FakeApi();
    api.config = const SdkConfig(
      projectName: 'Pocket Bartender',
      commentingEnabled: true,
      titleMax: 60,
      descriptionMax: 10000,
      commentMax: 10,
      attachmentMaxBytes: 5242880,
    );
    api.onGetFeedback = (id) async => detailWith([]);
    await openDetail(tester, api);

    final composer = find.byType(TextField);
    await tester.enterText(
        composer, 'far longer than the ten-character limit');
    expect(tester.widget<TextField>(composer).controller!.text, 'far longer');
  });

  testWidgets('404 on detail load pops back and removes the item from the list',
      (tester) async {
    final api = FakeApi();
    api.onGetFeedback = (id) async =>
        throw FeaturelyApiException(FeaturelyErrorCode.notFound, 404);
    await openDetail(tester, api);

    // Back on the list, and the row is gone.
    expect(find.text('Feedback'), findsOneWidget);
    expect(find.text('Offline mode for saved articles'), findsNothing);
  });
}
