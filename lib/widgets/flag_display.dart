import 'package:flutter/material.dart';
import 'package:semaphoreflow/models/semaphore_position.dart';
import 'package:semaphoreflow/widgets/semaphore_man_painter.dart';

class FlagDisplay extends StatefulWidget {
  final SemaphorePosition position;
  final bool isActive;
  final int index;
  final bool showLabel;
  final double scale;

  const FlagDisplay({
    super.key,
    required this.position,
    required this.isActive,
    required this.index,
    this.showLabel = true,
    this.scale = 1.0, // Default scale is 1.0
  });

  @override
  State<FlagDisplay> createState() => _FlagDisplayState();
}

class _FlagDisplayState extends State<FlagDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    if (widget.isActive) _controller.forward();
  }

  @override
  void didUpdateWidget(FlagDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? _scaleAnimation.value : 0.95,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: widget.isActive ? 1.0 : 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: widget.isActive
                    ? (isDarkMode ? const Color(0xFF1A1A1A) : Colors.white)
                    : (isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8FAFC)),
                border: Border.all(
                  color: widget.isActive
                      ? theme.colorScheme.primary
                      : (isDarkMode ? const Color(0xFF333333) : const Color(0xFFE2E8F0)),
                  width: widget.isActive ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Character Label
                  if (widget.showLabel)
                    Positioned(
                      bottom: 4,
                      right: 8,
                      child: Text(
                        widget.position.character.toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: widget.isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // Painter
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomPaint(
                      painter: SemaphoreManPainter(
                        leftAngle: widget.position.leftAngle,
                        rightAngle: widget.position.rightAngle,
                        isDarkMode: isDarkMode,
                        primaryColor: theme.colorScheme.primary,
                        scale: widget.scale, // Pass the scale to the painter
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
