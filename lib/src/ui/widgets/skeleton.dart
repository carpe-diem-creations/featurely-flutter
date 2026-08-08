import 'package:flutter/widgets.dart';

import '../scope.dart';

/// First-load skeleton rows with a subtle opacity shimmer, shaped like the
/// real rows (vote box + two text bars).
class SkeletonRows extends StatefulWidget {
  /// Creates the skeleton list.
  const SkeletonRows({this.count = 7, super.key});

  /// Number of placeholder rows.
  final int count;

  @override
  State<SkeletonRows> createState() => _SkeletonRowsState();
}

class _SkeletonRowsState extends State<SkeletonRows>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(_controller),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.count,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.field,
                  borderRadius: theme.borderRadius,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.64,
                      child: Container(
                        height: 13,
                        decoration: BoxDecoration(
                          color: theme.field,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FractionallySizedBox(
                      widthFactor: 0.36,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: theme.field.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
