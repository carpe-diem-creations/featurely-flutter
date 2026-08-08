import 'package:featurely/src/api/api_exception.dart';
import 'package:featurely/src/api/models.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> openFilter(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.filter_alt_outlined));
    await tester.pumpAndSettle();
  }

  testWidgets('filter count shows "N+" when the preview page was full',
      (tester) async {
    final api = FakeApi();
    api.onList = (sort, status, cursor, limit) async {
      if (limit == 100) {
        return Page(
          items: [for (var i = 0; i < 100; i++) makeItem(id: 'i$i')],
          nextCursor: 'more',
        );
      }
      return Page(items: [makeItem()], nextCursor: null);
    };
    await pumpSheet(tester, makeCore(api));
    await tester.pump();
    await openFilter(tester);

    expect(find.text('Show 100+ requests'), findsOneWidget);
  });

  testWidgets('filter count is exact when under the preview cap',
      (tester) async {
    final api = FakeApi();
    api.onList = (sort, status, cursor, limit) async => Page(
          items: [makeItem(id: 'a'), makeItem(id: 'b'), makeItem(id: 'c')],
          nextCursor: null,
        );
    await pumpSheet(tester, makeCore(api));
    await tester.pump();
    await openFilter(tester);

    expect(find.text('Show 3 requests'), findsOneWidget);
  });

  testWidgets('failed loadMore renders a retry footer that recovers',
      (tester) async {
    final api = FakeApi();
    // Scroll listeners re-invoke loadMore on every notification, so the
    // failure must persist until the test flips this off for Retry.
    var failLoadMore = true;
    api.onList = (sort, status, cursor, limit) async {
      if (cursor == null) {
        return Page(
          items: [for (var i = 0; i < 30; i++) makeItem(id: 'i$i')],
          nextCursor: 'cur-1',
        );
      }
      if (failLoadMore) throw FeaturelyNetworkException();
      return Page(items: [makeItem(id: 'appended')], nextCursor: null);
    };
    await pumpSheet(tester, makeCore(api));
    await tester.pump();

    // Scroll to the end (the list clamps) to trigger loadMore, which fails.
    await tester.drag(find.byType(ListView), const Offset(0, -4000));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    expect(
      find.text("Couldn't load feedback. Check your connection."),
      findsOneWidget,
    );

    failLoadMore = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('list rows render a one-line description excerpt',
      (tester) async {
    final api = FakeApi();
    api.onList = (sort, status, cursor, limit) async =>
        Page(items: [makeItem()], nextCursor: null);
    await pumpSheet(tester, makeCore(api));
    await tester.pump();

    expect(find.text('A longer description of the request.'), findsOneWidget);
  });
}
