import 'package:featurely/src/options.dart';
import 'package:featurely/src/ui/sandbox_strip.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('sandbox strip is present in the sandbox environment', (tester) async {
    final api = FakeApi();
    await pumpSheet(
      tester,
      makeCore(api, environment: FeaturelyEnvironment.sandbox),
    );
    await tester.pump();
    expect(find.byType(SandboxStrip), findsOneWidget);
    expect(find.text('SANDBOX'), findsOneWidget);
  });

  testWidgets('no strip in the live environment', (tester) async {
    final api = FakeApi();
    await pumpSheet(tester, makeCore(api, environment: FeaturelyEnvironment.live));
    await tester.pump();
    expect(find.byType(SandboxStrip), findsNothing);
    expect(find.text('SANDBOX'), findsNothing);
  });
}
