import 'dart:math';
import 'package:flutter/material.dart';
import 'package:semaphoreflow/theme.dart';

class SemaphoreManPainter extends CustomPainter {
  final double leftAngle;
  final double rightAngle;
  final bool isDarkMode;
  final Color primaryColor;
  final double scale;

  SemaphoreManPainter({
    required this.leftAngle,
    required this.rightAngle,
    required this.isDarkMode,
    required this.primaryColor,
    this.scale = 1.0, // Default scale is 1.0
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // The base scale is divided by 80, and then multiplied by the provided scale factor.
    final effectiveScale = (size.width / 80) * scale;

    final headRadius = 8 * effectiveScale;
    final torsoWidth = 20 * effectiveScale;
    final torsoHeight = 30 * effectiveScale;
    final armLength = 22 * effectiveScale;
    final stickLength = 10 * effectiveScale;
    final flagSize = 14 * effectiveScale;

    final bodyColor = isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final stickColor = const Color(0xFF8D6E63);

    final bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    final armPaint = Paint()
      ..color = bodyColor
      ..strokeWidth = 6 * effectiveScale
      ..strokeCap = StrokeCap.round;

    final headCenter = center - Offset(0, torsoHeight / 2 + headRadius - 2 * effectiveScale);
    canvas.drawCircle(headCenter, headRadius, bodyPaint);

    final torsoRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: torsoWidth,
        height: torsoHeight,
      ),
      Radius.circular(6 * effectiveScale),
    );
    canvas.drawRRect(torsoRect, bodyPaint);

    final shoulderY = center.dy - torsoHeight / 2 + 5 * effectiveScale;
    final leftShoulder = Offset(center.dx - torsoWidth / 2 + 2 * effectiveScale, shoulderY);
    final rightShoulder = Offset(center.dx + torsoWidth / 2 - 2 * effectiveScale, shoulderY);

    _drawLimb(
      canvas: canvas,
      shoulder: leftShoulder,
      angle: leftAngle,
      armLength: armLength,
      stickLength: stickLength,
      flagSize: flagSize,
      flagColor: SemaphoreColors.leftFlag,
      armPaint: armPaint,
      stickColor: stickColor,
      scale: effectiveScale,
      isLeft: true,
    );

    _drawLimb(
      canvas: canvas,
      shoulder: rightShoulder,
      angle: rightAngle,
      armLength: armLength,
      stickLength: stickLength,
      flagSize: flagSize,
      flagColor: SemaphoreColors.rightFlag,
      armPaint: armPaint,
      stickColor: stickColor,
      scale: effectiveScale,
      isLeft: false,
    );
  }

  void _drawLimb({
    required Canvas canvas,
    required Offset shoulder,
    required double angle,
    required double armLength,
    required double stickLength,
    required double flagSize,
    required Color flagColor,
    required Paint armPaint,
    required Color stickColor,
    required double scale,
    required bool isLeft,
  }) {
    final radians = (angle + 90) * pi / 180;
    final direction = isLeft ? -1.0 : 1.0;

    final handX = shoulder.dx + direction * armLength * cos(radians);
    final handY = shoulder.dy + armLength * sin(radians);
    final hand = Offset(handX, handY);

    canvas.drawLine(shoulder, hand, armPaint);
    canvas.drawCircle(hand, armPaint.strokeWidth / 2, armPaint);

    final stickEnd = Offset(
      hand.dx + direction * stickLength * cos(radians),
      hand.dy + stickLength * sin(radians),
    );

    final stickPaint = Paint()
      ..color = stickColor
      ..strokeWidth = 2.5 * scale
      ..strokeCap = StrokeCap.butt;

    canvas.drawLine(hand, stickEnd, stickPaint);

    canvas.save();
    canvas.translate(stickEnd.dx, stickEnd.dy);
    canvas.rotate(radians);

    final flagRect = Rect.fromCenter(
      center: Offset(flagSize / 2, 0),
      width: flagSize,
      height: flagSize,
    );

    final shadowPath = Path()..addRect(flagRect);
    canvas.drawPath(
      shadowPath.shift(Offset(1.5 * scale, 1.5 * scale)),
      Paint()
        ..color = const Color.fromRGBO(0, 0, 0, 0.15)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2 * scale),
    );

    final flagPaint = Paint()
      ..color = flagColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(flagRect, flagPaint);

    final path = Path()
      ..moveTo(flagRect.left, flagRect.bottom)
      ..lineTo(flagRect.right, flagRect.top)
      ..lineTo(flagRect.left, flagRect.top)
      ..close();

    canvas.drawPath(
      path,
      Paint()..color = const Color.fromRGBO(255, 255, 255, 0.15),
    );

    canvas.drawRect(
      flagRect,
      Paint()
        ..color = const Color.fromRGBO(0, 0, 0, 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8 * scale,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(SemaphoreManPainter oldDelegate) {
    return oldDelegate.leftAngle != leftAngle ||
        oldDelegate.rightAngle != rightAngle ||
        oldDelegate.isDarkMode != isDarkMode ||
        oldDelegate.scale != scale;
  }
}
