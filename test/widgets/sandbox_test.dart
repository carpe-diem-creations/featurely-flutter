import 'package:featurely/src/ui/sandbox_strip.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('sandbox strip is present with an fk_test_ key', (tester) async {
    final api = FakeApi();
    await pumpSheet(tester, makeCore(api, apiKey: 'fk_test_abc'));
    await tester.pump();
    expect(find.byType(SandboxStrip), findsOneWidget);
    expect(find.text('SANDBOX'), findsOneWidget);
  });

  testWidgets('no strip with an fk_live_ key', (tester) async {
    final api = FakeApi();
    await pumpSheet(tester, makeCore(api, apiKey: 'fk_live_abc'));
    await tester.pump();
    expect(find.byType(SandboxStrip), findsNothing);
    expect(find.text('SANDBOX'), findsNothing);
  });
}
