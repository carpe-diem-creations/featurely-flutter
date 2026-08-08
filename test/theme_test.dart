import 'package:featurely/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<FeaturelyThemeData> resolveWith(
  WidgetTester tester, {
  FeaturelyTheme? theme,
  Brightness hostBrightness = Brightness.light,
}) async {
  late FeaturelyThemeData resolved;
  // A raw Theme widget avoids MaterialApp's animated theme transition,
  // which would otherwise be read mid-lerp on consecutive pumps.
  await tester.pumpWidget(
    Theme(
      data: ThemeData(brightness: hostBrightness),
      child: Builder(
        builder: (context) {
          resolved = FeaturelyThemeData.resolve(context, theme);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return resolved;
}

void main() {
  testWidgets('onAccent contrast is computed from the accent color',
      (tester) async {
    final onDarkAccent = await resolveWith(
      tester,
      theme: const FeaturelyTheme(accentColor: Color(0xFF102040)),
    );
    expect(onDarkAccent.onAccent, Colors.white);

    final onLightAccent = await resolveWith(
      tester,
      theme: const FeaturelyTheme(accentColor: Color(0xFFFFEE58)),
    );
    expect(onLightAccent.onAccent, const Color(0xFF1B1C1F));
  });

  testWidgets('brightness inherits from the host theme by default',
      (tester) async {
    final light = await resolveWith(tester);
    expect(light.brightness, Brightness.light);
    expect(light.background, Colors.white);

    final dark =
        await resolveWith(tester, hostBrightness: Brightness.dark);
    expect(dark.brightness, Brightness.dark);
    expect(dark.background, const Color(0xFF121316));
  });

  testWidgets('FeaturelyTheme.brightness overrides the host theme',
      (tester) async {
    final forcedDark = await resolveWith(
      tester,
      theme: const FeaturelyTheme(brightness: Brightness.dark),
    );
    expect(forcedDark.brightness, Brightness.dark);
    expect(forcedDark.background, const Color(0xFF121316));
  });

  testWidgets('corner radius and font family knobs are applied',
      (tester) async {
    final themed = await resolveWith(
      tester,
      theme: const FeaturelyTheme(cornerRadius: 4, fontFamily: 'Inter'),
    );
    expect(themed.radius, 4);
    expect(themed.fontFamily, 'Inter');

    final defaults = await resolveWith(tester);
    expect(defaults.radius, 12);
    expect(defaults.fontFamily, isNull);
  });
}
