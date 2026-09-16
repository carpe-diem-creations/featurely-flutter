import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../api/api_client.dart';
import '../../api/api_exception.dart';
import '../../api/models.dart';
import '../../util/uuid.dart';

/// The chat screen's load phase.
enum ChatPhase {
  /// First load in flight.
  loading,

  /// First load failed (or a `401` arrived later) — the shared failed-load
  /// state with Retry.
  error,

  /// Messages (possibly none) are showing.
  loaded,
}

/// Delivery state of a message row.
enum ChatDelivery {
  /// Confirmed by the server.
  sent,

  /// Optimistic, awaiting the server.
  sending,

  /// The send failed — "Not sent — Tap to retry".
  failed,
}

/// A row in the chat: a server message, or a local optimistic one.
@immutable
class ChatEntry {
  /// Creates an entry.
  const ChatEntry({required this.message, required this.delivery});

  /// The message (for optimistic rows, [ChatMessage.id] is empty and
  /// [ChatMessage.clientMessageId] identifies the row).
  final ChatMessage message;

  /// Delivery state.
  final ChatDelivery delivery;

  /// Whether this row is still local (sending or failed).
  bool get isLocal => delivery != ChatDelivery.sent;
}

/// Outcome of the contact-email editor.
enum ChatEmailError {
  /// No error.
  none,

  /// The address was rejected (client check or `400 invalid_email`).
  invalid,

  /// The save failed for another reason.
  failed,
}

/// Controller for the In-App Chat screen: history paging, optimistic sends
/// with manual retry, the contact email, polling, and read markers.
///
/// Polling runs only while [setVisible] is true **and** the app is in the
/// foreground ([setForeground]); a `429` pauses it for [rateLimitPause].
/// Pending and failed messages live in memory only and are discarded with
/// the controller.
class ChatController extends ChangeNotifier {
  /// Creates the controller. [resolvedLocale] / [deviceLocale] are sent with
  /// each message so reply emails are localized.
  ChatController({
    required this.api,
    this.resolvedLocale,
    this.deviceLocale,
    this.pollInterval = const Duration(seconds: 5),
    this.rateLimitPause = const Duration(seconds: 30),
    String Function()? idGenerator,
  }) : _idGenerator = idGenerator ?? generateUuidV4;

  /// The API client.
  final FeaturelyApiClient api;

  /// The SDK's resolved locale tag, sent as `resolvedLocale`.
  final String? resolvedLocale;

  /// The device locale tag, sent as `deviceLocale`.
  final String? deviceLocale;

  /// Delay between polls while visible and foregrounded.
  final Duration pollInterval;

  /// How long polling pauses after a `429`.
  final Duration rateLimitPause;

  final String Function() _idGenerator;

  ChatPhase _phase = ChatPhase.loading;
  List<ChatMessage> _confirmed = [];
  final List<ChatEntry> _local = [];
  String? _olderCursor;
  String? _newerCursor;
  bool _loadingEarlier = false;
  bool _loadEarlierFailed = false;
  String? _contactEmail;
  bool _savingEmail = false;
  ChatEmailError _emailError = ChatEmailError.none;
  bool _rateLimitedNotice = false;

  bool _visible = false;
  bool _foreground = true;
  bool _rateLimited = false;
  bool _polling = false;
  bool _readInFlight = false;
  DateTime? _readThrough;
  Timer? _pollTimer;
  Timer? _pauseTimer;
  int _loadGeneration = 0;
  bool _disposed = false;

  /// The load phase.
  ChatPhase get phase => _phase;

  /// Every row, oldest first: confirmed messages, then local ones in the
  /// order they were composed.
  List<ChatEntry> get entries => List.unmodifiable([
        for (final message in _confirmed)
          ChatEntry(message: message, delivery: ChatDelivery.sent),
        ..._local,
      ]);

  /// Whether older history exists ("Load earlier").
  bool get canLoadEarlier => _olderCursor != null;

  /// Whether an older page is being fetched.
  bool get loadingEarlier => _loadingEarlier;

  /// Whether the last "Load earlier" failed.
  bool get loadEarlierFailed => _loadEarlierFailed;

  /// The saved contact email, if any.
  String? get contactEmail => _contactEmail;

  /// Whether the email is being saved.
  bool get savingEmail => _savingEmail;

  /// The email editor's error state.
  ChatEmailError get emailError => _emailError;

  /// Whether a `429` notice should show (cleared by the next success).
  bool get rateLimitedNotice => _rateLimitedNotice;

  /// Whether a poll timer is currently armed (for tests / diagnostics).
  @visibleForTesting
  bool get isPollScheduled => _pollTimer?.isActive ?? false;

  /// Whether polling is paused after a `429`.
  @visibleForTesting
  bool get isRateLimitPaused => _rateLimited;

  /// The cursor the next poll will send.
  @visibleForTesting
  String? get newerCursor => _newerCursor;

  bool get _shouldPoll =>
      !_disposed && _visible && _foreground && _phase == ChatPhase.loaded;

  /// Loads the conversation header and the newest page. A failure (any
  /// kind, `401` included) shows the failed-load state.
  Future<void> load() async {
    final generation = ++_loadGeneration;
    _cancelPoll();
    _phase = ChatPhase.loading;
    _notify();
    try {
      final results = await Future.wait<Object?>([
        api.getConversation(),
        api.getChatMessages(),
      ]);
      if (_disposed || generation != _loadGeneration) return;
      final conversation = results[0] as ChatConversation?;
      final page = results[1]! as ChatMessagesPage;
      _contactEmail = conversation?.contactEmail;
      _confirmed = [];
      _merge(page.messages);
      _olderCursor = page.olderCursor;
      _newerCursor = page.newerCursor;
      _loadEarlierFailed = false;
      // Nothing unread → the loaded team messages count as already read.
      if ((conversation?.unreadCount ?? 0) == 0) {
        _readThrough = _newestTeamMessageAt;
      }
      _phase = ChatPhase.loaded;
      _notify();
      unawaited(_maybeMarkRead());
      _schedulePoll(pollInterval);
    } catch (error) {
      if (_disposed || generation != _loadGeneration) return;
      _phase = ChatPhase.error;
      if (error is FeaturelyApiException &&
          error.code == FeaturelyErrorCode.rateLimited) {
        _startRateLimitPause();
      }
      _notify();
    }
  }

  /// Fetches the page before the oldest loaded message.
  Future<void> loadEarlier() async {
    final cursor = _olderCursor;
    if (cursor == null || _loadingEarlier || _phase != ChatPhase.loaded) {
      return;
    }
    _loadingEarlier = true;
    _loadEarlierFailed = false;
    _notify();
    try {
      final page = await api.getChatMessages(before: cursor);
      if (_disposed) return;
      _merge(page.messages);
      _olderCursor = page.olderCursor;
    } on FeaturelyApiException catch (error) {
      if (_disposed) return;
      if (error.code == FeaturelyErrorCode.invalidCursor) {
        _olderCursor = null; // Stale cursor: stop offering older history.
      } else {
        _loadEarlierFailed = true;
        if (error.code == FeaturelyErrorCode.rateLimited) {
          _startRateLimitPause();
        } else if (error.statusCode == 401) {
          _failHard();
        }
      }
    } catch (_) {
      if (_disposed) return;
      _loadEarlierFailed = true;
    } finally {
      if (!_disposed) {
        _loadingEarlier = false;
        _notify();
      }
    }
  }

  /// Sends [text] optimistically. Ignored when it is empty after trimming
  /// or longer than [chatMessageMax].
  Future<void> send(String text) async {
    final body = text.trim();
    if (body.isEmpty || body.length > chatMessageMax) return;
    final entry = ChatEntry(
      message: ChatMessage(
        id: '',
        author: ChatAuthor.user,
        body: body,
        createdAt: DateTime.now().toUtc(),
        clientMessageId: _idGenerator(),
      ),
      delivery: ChatDelivery.sending,
    );
    _local.add(entry);
    _notify();
    await _deliver(entry.message);
  }

  /// Re-sends the failed message [clientMessageId] with the same id (the
  /// server de-duplicates on it).
  Future<void> retry(String clientMessageId) async {
    final index = _localIndex(clientMessageId);
    if (index < 0 || _local[index].delivery != ChatDelivery.failed) return;
    final message = _local[index].message;
    _local[index] = ChatEntry(message: message, delivery: ChatDelivery.sending);
    _notify();
    await _deliver(message);
  }

  Future<void> _deliver(ChatMessage pending) async {
    final clientMessageId = pending.clientMessageId!;
    try {
      final stored = await api.sendChatMessage(
        body: pending.body,
        clientMessageId: clientMessageId,
        deviceLocale: deviceLocale,
        resolvedLocale: resolvedLocale,
      );
      if (_disposed) return;
      _local.removeWhere((e) => e.message.clientMessageId == clientMessageId);
      _merge([stored]);
      _rateLimitedNotice = false;
      _notify();
      // One immediate poll picks up anything the team sent meanwhile.
      unawaited(pollNow());
    } catch (error) {
      if (_disposed) return;
      final index = _localIndex(clientMessageId);
      if (index >= 0) {
        _local[index] =
            ChatEntry(message: pending, delivery: ChatDelivery.failed);
      }
      if (error is FeaturelyApiException) {
        if (error.code == FeaturelyErrorCode.rateLimited) {
          _rateLimitedNotice = true;
          _startRateLimitPause();
        } else if (error.statusCode == 401) {
          _failHard();
        }
      }
      _notify();
    }
  }

  /// Saves (or, when blank, clears) the contact email.
  Future<bool> saveEmail(String input) async {
    final email = input.trim();
    if (email.isNotEmpty && !looksLikeEmail(email)) {
      _emailError = ChatEmailError.invalid;
      _notify();
      return false;
    }
    _savingEmail = true;
    _emailError = ChatEmailError.none;
    _notify();
    try {
      await api.setChatEmail(email.isEmpty ? null : email);
      if (_disposed) return true;
      _contactEmail = email.isEmpty ? null : email;
      return true;
    } on FeaturelyApiException catch (error) {
      if (_disposed) return false;
      _emailError = error.code == FeaturelyErrorCode.invalidEmail
          ? ChatEmailError.invalid
          : ChatEmailError.failed;
      if (error.code == FeaturelyErrorCode.rateLimited) _startRateLimitPause();
      return false;
    } catch (_) {
      if (_disposed) return false;
      _emailError = ChatEmailError.failed;
      return false;
    } finally {
      if (!_disposed) {
        _savingEmail = false;
        _notify();
      }
    }
  }

  /// Clears the email editor's error (e.g. when the user edits the field).
  void clearEmailError() {
    if (_emailError == ChatEmailError.none) return;
    _emailError = ChatEmailError.none;
    _notify();
  }

  /// A lenient client-side address check; the server has the final word.
  static bool looksLikeEmail(String value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);

  /// Whether the chat route is on screen. Starts or stops polling.
  void setVisible(bool visible) {
    if (_visible == visible) return;
    _visible = visible;
    _onPollingInputsChanged();
  }

  /// Whether the app is in the foreground (`AppLifecycleState.resumed`).
  void setForeground(bool foreground) {
    if (_foreground == foreground) return;
    _foreground = foreground;
    _onPollingInputsChanged();
  }

  void _onPollingInputsChanged() {
    if (_shouldPoll) {
      // Back on screen: catch up right away (unless rate-limited).
      unawaited(pollNow());
    } else {
      _cancelPoll();
    }
  }

  /// Polls immediately when polling is allowed and not paused.
  Future<void> pollNow() async {
    if (!_shouldPoll || _rateLimited) return;
    _cancelPoll();
    await _poll();
  }

  Future<void> _poll() async {
    if (_polling) return;
    _polling = true;
    try {
      final generation = _loadGeneration;
      final cursor = _newerCursor;
      final page = await api.getChatMessages(after: cursor);
      if (_disposed || generation != _loadGeneration) return;
      final changed = _merge(page.messages);
      _newerCursor = page.newerCursor ?? cursor;
      // A cursor-less poll returned the newest page, which carries the
      // history cursor too.
      if (cursor == null && _olderCursor == null && page.olderCursor != null) {
        _olderCursor = page.olderCursor;
        _notify();
      }
      if (changed) _notify();
      await _maybeMarkRead();
    } on FeaturelyApiException catch (error) {
      if (_disposed) return;
      if (error.code == FeaturelyErrorCode.rateLimited) {
        _startRateLimitPause();
        return;
      }
      if (error.statusCode == 401) {
        _failHard();
        return;
      }
      if (error.code == FeaturelyErrorCode.invalidCursor) {
        _newerCursor = null; // Next poll re-reads the newest page.
      }
    } catch (_) {
      // Transient: try again next cycle.
    } finally {
      _polling = false;
      _schedulePoll(pollInterval);
    }
  }

  void _schedulePoll(Duration delay) {
    _cancelPoll();
    if (!_shouldPoll || _rateLimited) return;
    _pollTimer = Timer(delay, () => unawaited(_poll()));
  }

  void _cancelPoll() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void _startRateLimitPause() {
    _cancelPoll();
    _rateLimited = true;
    _pauseTimer?.cancel();
    _pauseTimer = Timer(rateLimitPause, () {
      _rateLimited = false;
      _pauseTimer = null;
      if (_shouldPoll) unawaited(_poll());
    });
  }

  void _failHard() {
    _cancelPoll();
    _phase = ChatPhase.error;
    _notify();
  }

  DateTime? get _newestTeamMessageAt {
    DateTime? newest;
    for (final message in _confirmed) {
      if (message.author != ChatAuthor.team) continue;
      if (newest == null || message.createdAt.isAfter(newest)) {
        newest = message.createdAt;
      }
    }
    return newest;
  }

  /// Calls `POST /conversation/read` when visible team messages are newer
  /// than the last read call — at most one call in flight.
  Future<void> _maybeMarkRead() async {
    if (!_visible || !_foreground || _readInFlight || _disposed) return;
    final newest = _newestTeamMessageAt;
    if (newest == null) return;
    final through = _readThrough;
    if (through != null && !newest.isAfter(through)) return;
    _readInFlight = true;
    try {
      await api.markChatRead();
      _readThrough = newest;
    } catch (_) {
      // Retried on the next cycle.
    } finally {
      _readInFlight = false;
    }
  }

  /// Inserts server messages, de-duplicated by id, replacing any optimistic
  /// row with the same `clientMessageId`, and keeps ascending order.
  bool _merge(List<ChatMessage> incoming) {
    if (incoming.isEmpty) return false;
    final byId = {for (final m in _confirmed) m.id: m};
    for (final message in incoming) {
      byId[message.id] = message;
      final cid = message.clientMessageId;
      if (cid != null) {
        _local.removeWhere((e) => e.message.clientMessageId == cid);
      }
    }
    _confirmed = byId.values.toList()
      ..sort((a, b) {
        final byTime = a.createdAt.compareTo(b.createdAt);
        return byTime != 0 ? byTime : a.id.compareTo(b.id);
      });
    return true;
  }

  int _localIndex(String clientMessageId) =>
      _local.indexWhere((e) => e.message.clientMessageId == clientMessageId);

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelPoll();
    _pauseTimer?.cancel();
    super.dispose();
  }
}
