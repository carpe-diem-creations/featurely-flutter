import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import '../../chat_metadata.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/chat_controller.dart';
import '../scope.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_email_row.dart';
import '../widgets/primary_button.dart';
import '../widgets/state_views.dart';

/// The In-App Chat screen: header, optional contact-email row, the message
/// list (newest at the bottom, "Load earlier" at the top), and the
/// composer.
///
/// Pushed from the list screen's "Message us" action, or shown as the root
/// of a standalone sheet by `Featurely.showChat`. Polls only while this
/// route is the visible one and the app is resumed.
class ChatScreen extends StatefulWidget {
  /// Creates the chat screen. [metadata] is per-presentation chat metadata,
  /// merged over the app-wide `Featurely.setChatMetadata` map on each send.
  const ChatScreen({this.metadata, super.key});

  /// Per-presentation chat metadata (null when opened from "Message us").
  final Map<String, String>? metadata;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late final ChatController _controller;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    final scope = FeaturelyScope.read(context);
    _controller = ChatController(
      api: scope.core.api,
      resolvedLocale: scope.localeTag,
      deviceLocale: PlatformDispatcher.instance.locale.toLanguageTag(),
      // Read at compose time, so a later setChatMetadata applies to new
      // messages (retries keep their own snapshot).
      metadata: () =>
          effectiveChatMetadata(scope.core.chatMetadata, widget.metadata),
    );
    WidgetsBinding.instance.addObserver(this);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _controller
      ..setForeground(
          lifecycle == null || lifecycle == AppLifecycleState.resumed)
      ..load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Both lookups register dependencies, so covering/uncovering this route
    // (or the host route of the whole sheet) re-runs this.
    final routeVisible = ModalRoute.of(context)?.isCurrent ?? true;
    final hostVisible = FeaturelyScope.of(context).hostVisible;
    _controller.setVisible(routeVisible && hostVisible);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller.setForeground(state == AppLifecycleState.resumed);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(String text) {
    _controller.send(text);
    if (_scroll.hasClients) {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = FeaturelyScope.of(context);
    final strings = FeaturelyLocalizations.of(context);
    final theme = scope.theme;
    final isRoot = !Navigator.of(context).canPop();
    return Material(
      color: theme.background,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 6),
              child: Row(
                children: [
                  if (isRoot)
                    CircleIconButton(
                      icon: Icons.close_rounded,
                      semanticLabel: strings.sdkCommonClose,
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    )
                  else
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip:
                            MaterialLocalizations.of(context).backButtonTooltip,
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: theme.accent,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        strings.sdkChatTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) => _buildBody(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final strings = FeaturelyLocalizations.of(context);
    switch (_controller.phase) {
      case ChatPhase.loading:
        return const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        );
      case ChatPhase.error:
        return ErrorStateView(onRetry: _controller.load);
      case ChatPhase.loaded:
        return Column(
          children: [
            ChatEmailRow(controller: _controller),
            if (_controller.rateLimitedNotice)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: InlineErrorBanner(message: strings.sdkCommonRateLimited),
              ),
            Expanded(child: _buildMessages(context)),
            ChatComposer(onSend: _send),
          ],
        );
    }
  }

  Widget _buildMessages(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    final entries = _controller.entries;
    if (entries.isEmpty && !_controller.canLoadEarlier) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.tint(theme.accent),
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    Icon(Icons.forum_outlined, size: 22, color: theme.accent),
              ),
              const SizedBox(height: 14),
              Text(
                strings.sdkChatEmptyGreeting,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.45,
                  color: theme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    final showHeader = _controller.canLoadEarlier;
    // Reversed: index 0 is the newest message, pinned to the bottom.
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.dragDetails != null &&
            notification.metrics.extentAfter < 80) {
          _controller.loadEarlier();
        }
        return false;
      },
      child: ListView.builder(
        controller: _scroll,
        reverse: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: entries.length + (showHeader ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= entries.length) return _buildLoadEarlier(context);
          final entry = entries[entries.length - 1 - index];
          final cid = entry.message.clientMessageId;
          return ChatBubble(
            key: ValueKey(entry.isLocal ? 'local-$cid' : entry.message.id),
            entry: entry,
            onRetry: cid == null ? null : () => _controller.retry(cid),
          );
        },
      ),
    );
  }

  Widget _buildLoadEarlier(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: _controller.loadingEarlier
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              )
            : TextButton(
                onPressed: _controller.loadEarlier,
                child: Text(
                  _controller.loadEarlierFailed
                      ? strings.sdkCommonRetry
                      : strings.sdkChatLoadEarlier,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.accent,
                  ),
                ),
              ),
      ),
    );
  }
}
