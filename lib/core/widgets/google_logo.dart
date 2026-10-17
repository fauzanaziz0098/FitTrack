import 'package:flutter/material.dart';

/// Crisp, vector-rendered official 4-color Google "G" logo
class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double strokeWidth = w * 0.20;
    final Rect strokeRect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      w - strokeWidth,
      h - strokeWidth,
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Red (top)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(strokeRect, -3.14159 * 0.75, 3.14159 * 0.5, false, paint);

    // Blue (top right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(strokeRect, -3.14159 * 0.25, 3.14159 * 0.45, false, paint);

    // Green (bottom)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(strokeRect, 3.14159 * 0.2, 3.14159 * 0.55, false, paint);

    // Yellow (bottom left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(strokeRect, 3.14159 * 0.75, 3.14159 * 0.5, false, paint);

    // Blue horizontal bar
    final Paint barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.45, h * 0.40, w * 0.95, h * 0.60),
      Radius.circular(w * 0.04),
    );
    canvas.drawRRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
