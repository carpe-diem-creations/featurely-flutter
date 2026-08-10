import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

Future<void> openForm(WidgetTester tester, FakeApi api) async {
  await pumpSheet(tester, makeCore(api));
  await tester.pump();
  await tester.tap(find.text('New feedback').last);
  await tester.pumpAndSettle();
}

Finder submitButton() => find.byType(PrimaryButton);

/// Fields in layout order: title, description, email.
Finder titleField() => find.byType(TextField).at(0);
Finder descriptionField() => find.byType(TextField).at(1);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('submit stays disabled until title and description are set',
      (tester) async {
    final api = FakeApi();
    await openForm(tester, api);

    PrimaryButton button() => tester.widget<PrimaryButton>(submitButton());
    expect(find.text('Submit'), findsOneWidget);
    expect(button().onPressed, isNull);

    await tester.enterText(titleField(), 'A title');
    await tester.pump();
    expect(button().onPressed, isNull);

    await tester.enterText(descriptionField(), 'A description');
    await tester.pump();
    expect(button().onPressed, isNotNull);
  });

  testWidgets('counter appears at 10 or fewer characters remaining',
      (tester) async {
    final api = FakeApi();
    await openForm(tester, api);
    await tester.enterText(titleField(), 'a' * 49);
    await tester.pump();
    expect(find.textContaining('characters left'), findsNothing);

    await tester.enterText(titleField(), 'a' * 50);
    await tester.pump();
    expect(find.text('10 characters left'), findsOneWidget);

    await tester.enterText(titleField(), 'a' * 59);
    await tester.pump();
    expect(find.text('1 character left'), findsOneWidget);
  });

  testWidgets('type toggle swaps the description placeholder with appName',
      (tester) async {
    final api = FakeApi();
    await openForm(tester, api);

    expect(
      find.text('What should Pocket Bartender do? '
          "Tell us how you'd use it."),
      findsOneWidget,
    );
    await tester.tap(find.text('Issue'));
    await tester.pump();
    expect(
      find.text('What went wrong in Pocket Bartender? '
          'Include what you expected to happen.'),
      findsOneWidget,
    );
    // Never the word "Bug" anywhere user-facing.
    expect(find.text('Bug'), findsNothing);
  });

  testWidgets('failure preserves the draft and relabels the button',
      (tester) async {
    final api = FakeApi();
    api.onSubmit = () async => throw Exception('offline');
    await openForm(tester, api);

    await tester.enterText(titleField(), 'Timer keeps running');
    await tester.enterText(descriptionField(), 'It just keeps going.');
    await tester.pump();
    await tester.tap(submitButton());
    await tester.pump();
    await tester.pump();

    expect(
      find.text("Couldn't send. Your draft is saved. "
          'Check your connection and try again.'),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);
    // Draft fields stay populated.
    expect(find.text('Timer keeps running'), findsOneWidget);
    expect(find.text('It just keeps going.'), findsOneWidget);
  });

  testWidgets('a 201 shows the success screen, and the list refreshes on return',
      (tester) async {
    final api = FakeApi();
    var listCalls = 0;
    api.onList = (sort, status, cursor, limit) async {
      listCalls++;
      return const Page(items: [], nextCursor: null);
    };
    api.onSubmit = () async => makeItem(title: 'Fresh item');
    await openForm(tester, api);

    await tester.enterText(titleField(), 'Title');
    await tester.enterText(descriptionField(), 'Description');
    await tester.pump();
    final before = listCalls;
    await tester.tap(submitButton());
    await tester.pumpAndSettle();

    expect(find.text('Thanks! We read every one of these.'), findsOneWidget);
    expect(
      find.text('Your feedback went straight to the Pocket Bartender team.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Back to feedback'));
    await tester.pumpAndSettle();
    expect(find.text('Feedback'), findsOneWidget);
    expect(listCalls, greaterThan(before));
  });

  testWidgets('a plan set mid-session is sent with the next submission',
      (tester) async {
    final api = FakeApi();
    api.onSubmit = () async => makeItem();
    final core = makeCore(api);
    await pumpSheet(tester, core);
    await tester.pump();
    await tester.tap(find.text('New feedback').last);
    await tester.pumpAndSettle();

    // What `Featurely.setPlan('Pro Monthly')` does after e.g. an upgrade.
    core.plan = 'Pro Monthly';

    await tester.enterText(titleField(), 'Title');
    await tester.enterText(descriptionField(), 'Description');
    await tester.pump();
    await tester.tap(submitButton());
    await tester.pumpAndSettle();

    expect(api.lastSubmissionMetadata?['plan'], 'Pro Monthly');
  });
}
