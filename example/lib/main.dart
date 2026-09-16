import 'package:featurely/featurely.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

/// Instance base URL and key are passed per build:
///
/// ```sh
/// flutter run \
///   --dart-define=FEATURELY_BASE_URL=http://localhost:3000 \
///   --dart-define=FEATURELY_API_KEY=fk_…
/// ```
///
/// Use `http://10.0.2.2:3000` for the Android emulator against a local
/// docker `featurely-app`. Debug builds report to Sandbox automatically
/// (with the visible SANDBOX strip); release builds report to Live.
const String baseUrl =
    String.fromEnvironment('FEATURELY_BASE_URL', defaultValue: 'http://localhost:3000');
const String apiKey =
    String.fromEnvironment('FEATURELY_API_KEY', defaultValue: 'fk_example');

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  static const accents = <Color>[
    Color(0xFFD9572B),
    Color(0xFF2563EB),
    Color(0xFF0E9888),
    Color(0xFF7C3AED),
  ];
  static const locales = <String?>[
    null, 'en', 'de', 'pt-BR', 'ar', 'ja', 'zh-TW', //
  ];

  Color accent = accents.first;
  double radius = 12;
  bool dark = false;
  String? localeTag;
  String userId = '';
  String? plan;

  Future<void> _reinit() {
    // init is idempotent — safe to call again with new knobs. The explicit
    // brightness exercises the FeaturelyTheme override (the sheet would
    // otherwise inherit it from the host theme anyway).
    return Featurely.init(
      baseUrl: baseUrl,
      apiKey: apiKey,
      plan: plan,
      theme: FeaturelyTheme(
        accentColor: accent,
        cornerRadius: radius,
        brightness: dark ? Brightness.dark : Brightness.light,
      ),
      locale: localeTag == null
          ? null
          : Locale(localeTag!.split('-').first,
              localeTag!.contains('-') ? localeTag!.split('-').last : null),
      onError: (operation, error) =>
          debugPrint('[featurely] $operation failed: $error'),
    );
  }

  @override
  void initState() {
    super.initState();
    _reinit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Featurely Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: dark ? Brightness.dark : Brightness.light,
        ),
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Featurely example')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Instance: $baseUrl',
                  style: Theme.of(context).textTheme.bodySmall),
              Text(
                'Environment: ${kDebugMode ? 'sandbox (debug build)' : 'live'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Featurely.show(context),
                child: const Text('Give feedback'),
              ),
              const Divider(height: 32),
              Text('Theming', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final color in accents)
                    GestureDetector(
                      onTap: () {
                        setState(() => accent = color);
                        _reinit();
                      },
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 18,
                        child: accent == color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  const Text('Radius'),
                  Expanded(
                    child: Slider(
                      value: radius,
                      min: 4,
                      max: 24,
                      divisions: 10,
                      label: '${radius.round()}',
                      onChanged: (value) => setState(() => radius = value),
                      onChangeEnd: (_) => _reinit(),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                title: const Text('Dark mode'),
                value: dark,
                onChanged: (value) {
                  setState(() => dark = value);
                  _reinit();
                },
              ),
              DropdownButtonFormField<String?>(
                initialValue: localeTag,
                decoration:
                    const InputDecoration(labelText: 'SDK locale override'),
                items: [
                  for (final tag in locales)
                    DropdownMenuItem(
                        value: tag, child: Text(tag ?? 'device locale')),
                ],
                onChanged: (value) {
                  setState(() => localeTag = value);
                  _reinit();
                },
              ),
              const Divider(height: 32),
              Text('Identity', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'External user id',
                  hintText: 'usr_9f2k1',
                ),
                onChanged: (value) => userId = value,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (userId.trim().isNotEmpty) {
                        Featurely.login(userId.trim());
                      }
                    },
                    child: const Text('login'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: Featurely.logout,
                    child: const Text('logout'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                initialValue: plan,
                decoration: const InputDecoration(labelText: 'Plan'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('none')),
                  DropdownMenuItem(value: 'Free', child: Text('Free')),
                  DropdownMenuItem(
                      value: 'Pro Monthly', child: Text('Pro Monthly')),
                  DropdownMenuItem(
                      value: 'Pro Annual', child: Text('Pro Annual')),
                ],
                onChanged: (value) {
                  plan = value;
                  Featurely.setPlan(value);
                  Featurely.setChatMetadata({if (value != null) 'plan': value});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
