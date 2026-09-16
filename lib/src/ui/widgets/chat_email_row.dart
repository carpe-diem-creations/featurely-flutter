import 'package:flutter/material.dart';

import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/chat_controller.dart';
import '../scope.dart';

/// The optional "Get replies by email" row. Collapsed it is a single
/// prompt; tapped it opens an email field with Save; once saved it shows the
/// address with an Edit action.
class ChatEmailRow extends StatefulWidget {
  /// Creates the row bound to [controller].
  const ChatEmailRow({required this.controller, super.key});

  /// The chat controller (source of the saved address and save state).
  final ChatController controller;

  @override
  State<ChatEmailRow> createState() => _ChatEmailRowState();
}

class _ChatEmailRowState extends State<ChatEmailRow> {
  final TextEditingController _field = TextEditingController();
  bool _editing = false;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  void _startEditing() {
    _field.text = widget.controller.contactEmail ?? '';
    widget.controller.clearEmailError();
    setState(() => _editing = true);
  }

  Future<void> _save() async {
    final saved = await widget.controller.saveEmail(_field.text);
    if (saved && mounted) setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    final controller = widget.controller;
    final saved = controller.contactEmail;

    final Widget child;
    if (_editing) {
      final error = switch (controller.emailError) {
        ChatEmailError.invalid => strings.sdkChatEmailInvalid,
        ChatEmailError.failed => strings.sdkFormSubmitError,
        ChatEmailError.none => null,
      };
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('featurely-chat-email-field'),
                  controller: _field,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => controller.clearEmailError(),
                  onSubmitted: (_) => _save(),
                  decoration: InputDecoration(
                    hintText: strings.sdkChatEmailPlaceholder,
                    hintStyle:
                        TextStyle(fontSize: 14, color: theme.textTertiary),
                    filled: true,
                    fillColor: theme.background,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: theme.borderRadius,
                      borderSide: BorderSide(
                        color:
                            error != null ? theme.errorBorder : theme.hairline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: theme.borderRadius,
                      borderSide: BorderSide(
                        color:
                            error != null ? theme.errorBorder : theme.hairline,
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 14, color: theme.textPrimary),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: controller.savingEmail ? null : _save,
                child: controller.savingEmail
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        strings.sdkChatEmailSave,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.accent,
                        ),
                      ),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4, top: 4),
              child: Text(
                error,
                style: TextStyle(fontSize: 12, color: theme.errorForeground),
              ),
            ),
        ],
      );
    } else if (saved != null) {
      child = Row(
        children: [
          Icon(Icons.mail_outline_rounded, size: 18, color: theme.textTertiary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.sdkChatEmailSaved,
                  style: TextStyle(fontSize: 11.5, color: theme.textTertiary),
                ),
                Text(
                  saved,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 14, color: theme.textPrimary),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _startEditing,
            child: Text(
              strings.sdkChatEmailEdit,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.accent,
              ),
            ),
          ),
        ],
      );
    } else {
      child = InkWell(
        onTap: _startEditing,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(Icons.mail_outline_rounded, size: 18, color: theme.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  strings.sdkChatEmailPrompt,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.accent,
                  ),
                ),
              ),
              // arrow_forward_ios carries matchTextDirection (RTL-safe).
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 12, color: theme.textTertiary),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.field,
        border: Border(bottom: BorderSide(color: theme.hairline, width: 0.5)),
      ),
      child: child,
    );
  }
}
