import 'dart:math';
import 'package:flutter/material.dart';
import 'package:semaphoreflow/theme.dart';

class SemaphoreFlagPainter extends CustomPainter {
  final double leftAngle;
  final double rightAngle;
  final bool isDarkMode;

  SemaphoreFlagPainter({
    required this.leftAngle,
    required this.rightAngle,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final armLength = size.width * 0.3; // Reduced for better fit

    // Draw center dot
    final centerPaint = Paint()
      ..color = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.02, centerPaint); // Reduced

    // Draw left flag (blue)
    _drawFlag(
      canvas,
      center,
      leftAngle,
      armLength,
      SemaphoreColors.leftFlag,
      size.width,
      true, // isLeft arm
    );

    // Draw right flag (red)
    _drawFlag(
      canvas,
      center,
      rightAngle,
      armLength,
      SemaphoreColors.rightFlag,
      size.width,
      false, // isLeft arm
    );
  }

  void _drawFlag(
    Canvas canvas,
    Offset center,
    double semaphoreAngle,
    double armLength,
    Color flagColor,
    double size,
    bool isLeft,
  ) {
    if (semaphoreAngle == 0 && leftAngle == 0 && rightAngle == 0) {
      return; // Don't draw for space character
    }

    // Convert semaphore angle to radians for Flutter coordinate system
    // Semaphore: 0° = Down, 90° = Sideways, 180° = Up
    // Flutter: 0° = Right/East, 90° = Down/South
    // Conversion: Add 90° to convert Down(0°) to South(90°)
    final radians = (semaphoreAngle + 90) * pi / 180;

    // For left arm, we need to mirror the direction
    final direction = isLeft ? -1.0 : 1.0;
    final endX = center.dx + direction * armLength * cos(radians);
    final endY = center.dy + armLength * sin(radians);
    final endPoint = Offset(endX, endY);

    // Draw arm (pole)
    final armPaint = Paint()
      ..color = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade600
      ..strokeWidth = size * 0.01 // Reduced
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, endPoint, armPaint);

    // Reduced flag dimensions for better fit
    final flagWidth = size * 0.06; // Reduced
    final flagHeight = size * 0.09; // Reduced

    // Calculate flag position (at the end of the arm)
    final flagAngle = radians + pi / 2;
    final flagCenter = endPoint;

    // Create flag path
    final flagPath = Path();

    // Calculate the four corners of the flag rectangle
    final topLeft = Offset(
      flagCenter.dx - flagWidth / 2 * cos(flagAngle) - flagHeight * cos(radians),
      flagCenter.dy - flagWidth / 2 * sin(flagAngle) - flagHeight * sin(radians),
    );

    final topRight = Offset(
      flagCenter.dx + flagWidth / 2 * cos(flagAngle) - flagHeight * cos(radians),
      flagCenter.dy + flagWidth / 2 * sin(flagAngle) - flagHeight * sin(radians),
    );

    final bottomRight = Offset(
      flagCenter.dx + flagWidth / 2 * cos(flagAngle),
      flagCenter.dy + flagWidth / 2 * sin(flagAngle),
    );

    final bottomLeft = Offset(
      flagCenter.dx - flagWidth / 2 * cos(flagAngle),
      flagCenter.dy - flagWidth / 2 * sin(flagAngle),
    );

    flagPath.moveTo(topLeft.dx, topLeft.dy);
    flagPath.lineTo(topRight.dx, topRight.dy);
    flagPath.lineTo(bottomRight.dx, bottomRight.dy);
    flagPath.lineTo(bottomLeft.dx, bottomLeft.dy);
    flagPath.close();

    // Draw flag shadow (reduced blur)
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2) // Fixed: withOpacity instead of withValues
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size * 0.005); // Reduced
    canvas.drawPath(flagPath.shift(Offset(size * 0.003, size * 0.003)), shadowPaint);

    // Draw flag
    final flagPaint = Paint()
      ..color = flagColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(flagPath, flagPaint);

    // Add subtle gradient effect
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          flagColor.withOpacity(0.9), // Fixed: withOpacity instead of withValues
          flagColor,
          flagColor.withOpacity(0.8), // Fixed: withOpacity instead of withValues
        ],
      ).createShader(Rect.fromCircle(center: flagCenter, radius: flagHeight));
    canvas.drawPath(flagPath, gradientPaint);

    // Draw flag border for definition
    final borderPaint = Paint()
      ..color = isDarkMode
          ? flagColor.withOpacity(0.5) // Fixed: withOpacity instead of withValues
          : Colors.black.withOpacity(0.1) // Fixed: withOpacity instead of withValues
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.002; // Reduced
    canvas.drawPath(flagPath, borderPaint);
  }

  @override
  bool shouldRepaint(SemaphoreFlagPainter oldDelegate) {
    return oldDelegate.leftAngle != leftAngle ||
        oldDelegate.rightAngle != rightAngle ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
