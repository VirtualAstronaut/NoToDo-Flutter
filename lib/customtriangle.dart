import 'package:flutter/material.dart';
import 'package:flutter_app/animatedcolors.dart';

class AnimatedCustomTriangle extends CustomPainter {
  Animation<Color> _color;
  AnimatedCustomTriangle(Animation<double> animation)
      : _color = AnimatedColors.circleColor.animate(animation),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = _color.value
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint_0);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
