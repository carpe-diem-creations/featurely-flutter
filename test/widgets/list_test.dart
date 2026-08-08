import 'dart:async';

import 'package:featurely/src/api/api_exception.dart';
import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/ui/widgets/skeleton.dart';
import 'package:featurely/src/ui/widgets/vote_box.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('first load shows skeletons, then items', (tester) async {
    final api = FakeApi();
    final completer = Completer<Page<FeedbackItem>>();
    api.onList = (sort, status, cursor, limit) => completer.future;
    await pumpSheet(tester, makeCore(api));

    expect(find.byType(SkeletonRows), findsOneWidget);

    completer.complete(Page(items: [makeItem()], nextCursor: null));
    await tester.pump();
    await tester.pump();

    expect(find.byType(SkeletonRows), findsNothing);
    expect(find.text('Offline mode for saved articles'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('optimistic vote flips instantly then reconciles', (tester) async {
    final api = FakeApi();
    api.onList = (sort, status, cursor, limit) async =>
        Page(items: [makeItem(votes: 12)], nextCursor: null);
    final voteCompleter = Completer<VoteResult>();
    api.onVote = (id) => voteCompleter.future;
    await pumpSheet(tester, makeCore(api));
    await tester.pump();

    expect(find.text('12'), findsOneWidget);
    await tester.tap(find.byType(VoteBox));
    await tester.pump();
    // Optimistic flip before the server answers.
    expect(find.text('13'), findsOneWidget);

    // Server reconciles to a different number (another device voted too).
    voteCompleter.complete(const VoteResult(votes: 15, viewerHasVoted: true));
    await tester.pump();
    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('vote reverts on failure', (tester) async {
    final api = FakeApi();
    api.onList = (sort, status, cursor, limit) async =>
        Page(items: [makeItem(votes: 12)], nextCursor: null);
    api.onVote = (id) async => throw FeaturelyNetworkException();
    await pumpSheet(tester, makeCore(api));
    await tester.pump();

    await tester.tap(find.byType(VoteBox));
    await tester.pump();
    expect(find.text('12'), findsOneWidget);
    expect(find.text('13'), findsNothing);
  });

  testWidgets('vote 404 removes the item from the list', (tester) async {
    final api = FakeApi();
    api.onList = (sort, status, cursor, limit) async =>
        Page(items: [makeItem()], nextCursor: null);
    api.onVote =
        (id) async => throw FeaturelyApiException(FeaturelyErrorCode.notFound, 404);
    await pumpSheet(tester, makeCore(api));
    await tester.pump();

    await tester.tap(find.byType(VoteBox));
    await tester.pump();
    expect(find.text('Offline mode for saved articles'), findsNothing);
  });

  testWidgets('empty and error states are distinct', (tester) async {
    final api = FakeApi();
    var fail = true;
    api.onList = (sort, status, cursor, limit) async {
      if (fail) throw FeaturelyNetworkException();
      return const Page(items: [], nextCursor: null);
    };
    await pumpSheet(tester, makeCore(api));
    await tester.pump();

    // Failed load: error copy + Retry, no empty copy.
    expect(find.text("Couldn't load feedback. Check your connection."),
        findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.textContaining('Nothing here yet'), findsNothing);

    // Retry succeeds into the distinct empty state (CTA still present).
    fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('Nothing here yet'), findsOneWidget);
    expect(find.text('New feedback'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('filter sheet shows the live result count', (tester) async {
    final api = FakeApi();
    api.onList = (sort, status, cursor, limit) async => Page(
          items: List.generate(7, (i) => makeItem(id: 'i$i', title: 'Item $i')),
          nextCursor: null,
        );
    await pumpSheet(tester, makeCore(api));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.filter_alt_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Show 7 requests'), findsOneWidget);
    expect(find.text('Most voted'), findsOneWidget);
    // Declined never exists in the SDK.
    expect(find.text('Declined'), findsNothing);
  });

}
