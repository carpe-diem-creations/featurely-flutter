import 'package:flutter/material.dart';

import '../scope.dart';

/// The tappable vote box on list rows: chevron + count, accent-filled when
/// the viewer has voted. The toggle renders instantly (optimistic).
class VoteBox extends StatelessWidget {
  /// Creates a vote box.
  const VoteBox({
    required this.votes,
    required this.voted,
    required this.onTap,
    super.key,
  });

  /// The vote count to display.
  final int votes;

  /// Whether the viewer's identity has voted.
  final bool voted;

  /// Toggle callback.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return Semantics(
      button: true,
      selected: voted,
      child: Material(
        color: voted ? theme.accent : theme.background,
        borderRadius: theme.borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: theme.borderRadius,
          child: Container(
            width: 46,
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(
                color: voted ? theme.accent : theme.border,
                width: 1.5,
              ),
              borderRadius: theme.borderRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 18,
                  color: voted ? theme.onAccent : theme.textSecondary,
                ),
                Text(
                  '$votes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: voted ? theme.onAccent : theme.textSecondary,
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
