import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/ui/screens/list_screen.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('ar renders RTL regardless of an LTR host app', (tester) async {
    final api = FakeApi();
    api.onList = (sort, status, cursor, limit) async =>
        Page(items: [makeItem()], nextCursor: null);
    // Host app is English/LTR; the SDK subtree resolves ar itself.
    await pumpSheet(tester, makeCore(api, locale: const Locale('ar')));
    await tester.pump();

    final listContext = tester.element(find.byType(ListScreen));
    expect(Directionality.of(listContext), TextDirection.rtl);
    expect(Localizations.localeOf(listContext).languageCode, 'ar');
    // The English title must not appear; the Arabic catalog is used.
    expect(find.text('Feedback'), findsNothing);
  });

  testWidgets('de renders its catalog with the correct locale', (tester) async {
    final api = FakeApi();
    await pumpSheet(tester, makeCore(api, locale: const Locale('de')));
    await tester.pump();
    await tester.pump();
    expect(find.text('Neues Feedback'), findsOneWidget);
  });

  testWidgets('an unsupported regional locale collapses to its base language',
      (tester) async {
    final api = FakeApi();
    await pumpSheet(tester, makeCore(api, locale: const Locale('de', 'CH')));
    await tester.pump();
    await tester.pump();
    expect(find.text('Neues Feedback'), findsOneWidget);
  });

  testWidgets('long German strings do not overflow the form on a narrow screen',
      (tester) async {
    final api = FakeApi();
    final core = makeCore(api, locale: const Locale('de'));
    await pumpSheet(tester, core, surface: const Size(320, 700));
    await tester.pump();
    await tester.tap(find.text('Neues Feedback').last);
    await tester.pumpAndSettle();

    // Buttons and fields laid out without overflow exceptions.
    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsWidgets);
  });
}
