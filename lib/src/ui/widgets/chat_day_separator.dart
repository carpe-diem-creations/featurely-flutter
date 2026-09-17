import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/chat_controller.dart';
import '../scope.dart';

/// The local calendar day [entry] belongs to. Pending and failed rows
/// always count as today.
DateTime chatEntryDay(ChatEntry entry, DateTime now) {
  final date = entry.isLocal ? now : entry.message.createdAt.toLocal();
  return DateTime(date.year, date.month, date.day);
}

/// Whether the row at [index] of the ascending [entries] starts a new local
/// day, i.e. needs a day separator above it.
bool chatStartsDay(List<ChatEntry> entries, int index, DateTime now) =>
    index == 0 ||
    chatEntryDay(entries[index], now) != chatEntryDay(entries[index - 1], now);

/// The separator label for [date] relative to [now] (both compared as local
/// calendar days): Today, Yesterday, a weekday within the last six days,
/// month and day within the same year, otherwise the full medium date.
String chatDayLabel(
  DateTime date, {
  required DateTime now,
  required String locale,
  required FeaturelyLocalizations strings,
}) {
  final local = date.toLocal();
  final today = now.toLocal();
  // Whole calendar days between the two, computed in UTC so DST shifts
  // don't turn a day into 23 or 25 hours.
  final days = DateTime.utc(today.year, today.month, today.day)
      .difference(DateTime.utc(local.year, local.month, local.day))
      .inDays;
  // A server clock slightly ahead of the device still reads as today.
  if (days <= 0) return strings.sdkChatToday;
  if (days == 1) return strings.sdkChatYesterday;
  if (days <= 6) return DateFormat.EEEE(locale).format(local);
  if (local.year == today.year) return DateFormat.MMMd(locale).format(local);
  return DateFormat.yMMMd(locale).format(local);
}

/// A centered, quiet day label in the chat message list.
class ChatDaySeparator extends StatelessWidget {
  /// Creates a separator showing [label].
  const ChatDaySeparator({required this.label, super.key});

  /// The localized day label (see [chatDayLabel]).
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return Padding(
      // With the rows' own 6pt padding this keeps the 12pt rhythm plus ~2pt.
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Semantics(
        header: true,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: theme.textTertiary),
        ),
      ),
    );
  }
}
