import 'package:flutter/material.dart';

import '../scope.dart';

/// The full-width 50pt accent button (New feedback CTA, Submit, Show N
/// requests), with disabled and in-place-spinner states per the design.
class PrimaryButton extends StatelessWidget {
  /// Creates a button.
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.busy = false,
    super.key,
  });

  /// Button label.
  final String label;

  /// Tap callback; null renders the disabled state.
  final VoidCallback? onPressed;

  /// Shows an in-place spinner next to the label (e.g. "Sending…").
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final enabled = onPressed != null && !busy;
    return Semantics(
      button: true,
      enabled: enabled,
      child: Material(
        color: enabled || busy ? theme.accent : theme.disabledBackground,
        borderRadius: theme.borderRadius,
        elevation: enabled ? 3 : 0,
        shadowColor: theme.accent.withValues(alpha: 0.35),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: theme.borderRadius,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (busy) ...[
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation(theme.onAccent),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: enabled || busy
                          ? theme.onAccent
                          : theme.disabledForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The outlined accent button (Retry, Back to feedback).
class OutlinedAccentButton extends StatelessWidget {
  /// Creates a button.
  const OutlinedAccentButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// Button label.
  final String label;

  /// Tap callback.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return Material(
      color: Colors.transparent,
      borderRadius: theme.borderRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: theme.borderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 11),
          decoration: BoxDecoration(
            border: Border.all(color: theme.accent, width: 1.5),
            borderRadius: theme.borderRadius,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.accent,
            ),
          ),
        ),
      ),
    );
  }
}

/// The circular 40pt header icon button (close, filter, send).
class CircleIconButton extends StatelessWidget {
  /// Creates a button.
  const CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
    this.filled = false,
    this.size = 40,
    super.key,
  });

  /// The icon.
  final IconData icon;

  /// Tap callback.
  final VoidCallback onTap;

  /// Accessibility label.
  final String semanticLabel;

  /// Accent-filled variant (active filter, send).
  final bool filled;

  /// Diameter.
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: filled ? theme.accent : theme.field,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              size: size * 0.5,
              color: filled ? theme.onAccent : theme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
