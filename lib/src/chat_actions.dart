import 'package:flutter/foundation.dart';

/// An in-app action the AI support assistant may suggest in chat, such as
/// "Open Settings" or "Try again". Register them with
/// `Featurely.registerChatActions` and handle taps with
/// `Featurely.setChatActionHandler`.
@immutable
class FeaturelyChatAction {
  /// Creates an action. [id] is the stable identifier the assistant refers
  /// to (`^[a-z][a-z0-9_]{0,39}$`, e.g. `'open_settings'`); [title] is the
  /// button label shown to the user, already localized by the host app.
  const FeaturelyChatAction({required this.id, required this.title});

  /// The stable action id sent to the server as one of `availableActions`.
  final String id;

  /// The localized button label.
  final String title;

  @override
  bool operator ==(Object other) =>
      other is FeaturelyChatAction && other.id == id && other.title == title;

  @override
  int get hashCode => Object.hash(id, title);

  @override
  String toString() => 'FeaturelyChatAction($id)';
}

/// What the chat does after the host app handled a tapped assistant action.
enum FeaturelyChatActionResult {
  /// Keep the chat open.
  stay,

  /// Close the chat sheet (the route `Featurely.showChat` — or
  /// `Featurely.show` — pushed).
  dismiss,
}

/// The most action ids a message send may advertise.
const int chatActionsMax = 12;

/// The pattern every action id must match.
final RegExp chatActionIdPattern = RegExp(r'^[a-z][a-z0-9_]{0,39}$');

/// Cleans a host-supplied action list to what the server accepts: drops
/// actions whose id doesn't match [chatActionIdPattern] or whose title is
/// blank, keeps the first of any duplicate id, and caps the list at
/// [chatActionsMax]. Never throws; dropped input is reported with
/// `debugPrint` in debug builds. Returns an unmodifiable list.
List<FeaturelyChatAction> cleanChatActions(List<FeaturelyChatAction> actions) {
  final result = <FeaturelyChatAction>[];
  final seen = <String>{};
  for (final action in actions) {
    final title = action.title.trim();
    if (!chatActionIdPattern.hasMatch(action.id)) {
      _debugLog('dropped action "${action.id}": the id must match '
          '${chatActionIdPattern.pattern}');
    } else if (title.isEmpty) {
      _debugLog('dropped action "${action.id}": blank title');
    } else if (!seen.add(action.id)) {
      _debugLog('dropped a duplicate of action "${action.id}"');
    } else if (result.length == chatActionsMax) {
      _debugLog('dropped action "${action.id}": at most $chatActionsMax '
          'actions can be registered');
    } else {
      result.add(FeaturelyChatAction(id: action.id, title: title));
    }
  }
  return List.unmodifiable(result);
}

void _debugLog(String message) {
  if (kDebugMode) debugPrint('Featurely chat actions: $message');
}
