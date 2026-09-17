import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/l10n/generated/featurely_localizations.dart';
import 'package:featurely/src/ui/controllers/chat_controller.dart';
import 'package:featurely/src/ui/widgets/chat_day_separator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

ChatEntry _entry(DateTime createdAt,
        {ChatDelivery delivery = ChatDelivery.sent}) =>
    ChatEntry(
      message: ChatMessage(
        id: delivery == ChatDelivery.sent ? '$createdAt' : '',
        author: ChatAuthor.user,
        body: 'x',
        createdAt: createdAt,
        clientMessageId: delivery == ChatDelivery.sent ? null : 'c1',
      ),
      delivery: delivery,
    );

void main() {
  setUpAll(() => initializeDateFormatting());

  // Thursday, 17 September 2026, mid-afternoon local time.
  final now = DateTime(2026, 9, 17, 15, 30);
  final en = lookupFeaturelyLocalizations(const Locale('en'));
  final de = lookupFeaturelyLocalizations(const Locale('de'));

  String label(DateTime date,
          {String locale = 'en', FeaturelyLocalizations? strings}) =>
      chatDayLabel(date, now: now, locale: locale, strings: strings ?? en);

  group('chatDayLabel', () {
    test('today and yesterday use the localized words', () {
      expect(label(DateTime(2026, 9, 17, 0, 1)), 'Today');
      expect(label(DateTime(2026, 9, 17, 23, 59)), 'Today');
      expect(label(DateTime(2026, 9, 16, 23, 59)), 'Yesterday');
      expect(label(DateTime(2026, 9, 16, 0, 0)), 'Yesterday');
      expect(label(DateTime(2026, 9, 17), locale: 'de', strings: de), 'Heute');
      expect(
          label(DateTime(2026, 9, 16), locale: 'de', strings: de), 'Gestern');
    });

    test('a slightly future timestamp still reads as today', () {
      expect(label(DateTime(2026, 9, 18, 0, 5)), 'Today');
    });

    test('two to six days back show the weekday', () {
      expect(label(DateTime(2026, 9, 15, 9)), 'Tuesday');
      expect(label(DateTime(2026, 9, 11, 9)), 'Friday');
      expect(label(DateTime(2026, 9, 14), locale: 'de', strings: de), 'Montag');
    });

    test('a week or more back in the same year shows month and day', () {
      expect(label(DateTime(2026, 9, 10, 9)), 'Sep 10');
      expect(label(DateTime(2026, 1, 1)), 'Jan 1');
    });

    test('earlier years include the year', () {
      expect(label(DateTime(2025, 12, 31, 9)), 'Dec 31, 2025');
      expect(label(DateTime(2025, 9, 17)), 'Sep 17, 2025');
    });

    test('compares local calendar days, not 24-hour spans', () {
      final lateNight = DateTime(2026, 9, 17, 0, 10);
      // Only ~10 minutes before "now", but on the previous day.
      expect(
        chatDayLabel(DateTime(2026, 9, 16, 23, 59),
            now: lateNight, locale: 'en', strings: en),
        'Yesterday',
      );
      // DST (e.g. late March in Europe) doesn't shift the day count.
      expect(
        chatDayLabel(DateTime(2026, 3, 28, 12),
            now: DateTime(2026, 3, 30, 0, 30), locale: 'en', strings: en),
        'Saturday',
      );
    });
  });

  group('chatStartsDay', () {
    test('marks the first row of each local day', () {
      final entries = [
        _entry(DateTime(2026, 9, 14, 9)),
        _entry(DateTime(2026, 9, 14, 18)),
        _entry(DateTime(2026, 9, 16, 8)),
        _entry(DateTime(2026, 9, 17, 8)),
        _entry(DateTime(2026, 9, 17, 9)),
      ];
      expect(
        [
          for (var i = 0; i < entries.length; i++)
            chatStartsDay(entries, i, now)
        ],
        [true, false, true, true, false],
      );
    });

    test('pending and failed rows count as today', () {
      final entries = [
        _entry(DateTime(2026, 9, 16, 8)),
        // A stale compose time must not open a separate day.
        _entry(DateTime(2026, 9, 15), delivery: ChatDelivery.failed),
        _entry(DateTime(2026, 9, 17), delivery: ChatDelivery.sending),
      ];
      expect(chatStartsDay(entries, 1, now), isTrue);
      expect(chatStartsDay(entries, 2, now), isFalse);
      expect(chatEntryDay(entries[1], now), DateTime(2026, 9, 17));
    });

    test('works on UTC server timestamps', () {
      final utc = DateTime.utc(2026, 9, 16, 12);
      final local = utc.toLocal();
      expect(chatEntryDay(_entry(utc), now),
          DateTime(local.year, local.month, local.day));
    });
  });
}
