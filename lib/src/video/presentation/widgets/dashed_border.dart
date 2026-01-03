import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  const DashedBorder({
    required this.child,
    this.strokeWidth = 2.0,
    this.color = Colors.grey,
    this.gap = 8.0,
    this.borderRadius = 8.0,
    this.onTap,
    super.key,
  });

  final Widget child;
  final double strokeWidth;
  final Color color;
  final double gap;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      // Crucial for catching drops/taps inside empty space
      child: CustomPaint(
        painter: _DashedRectPainter(
          strokeWidth: strokeWidth,
          color: color,
          gap: gap,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  _DashedRectPainter({
    required this.strokeWidth,
    required this.color,
    required this.gap,
    required this.borderRadius,
  });

  final double strokeWidth;
  final Color color;
  final double gap;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = Path();
    double distance = 0;

    // Create dashed path metric
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap * 1.5),
          Offset.zero,
        );
        distance += gap * 3; // Space + Dash
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
