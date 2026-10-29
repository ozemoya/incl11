import 'package:flutter/material.dart';

class CreatureCollage extends StatelessWidget {
  const CreatureCollage({super.key, this.height = 230});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _CreaturePainter()),
    );
  }
}

class _CreaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 400, size.height / 240);
    final paint = Paint();
    void block(Rect rect, Color color) {
      paint.color = color;
      canvas.drawRect(rect, paint);
    }

    block(const Rect.fromLTWH(20, 174, 115, 38), const Color(0xFF8A68BB));
    block(const Rect.fromLTWH(132, 195, 220, 24), const Color(0xFFFFCA42));
    block(const Rect.fromLTWH(239, 168, 130, 32), const Color(0xFFED4C39));
    for (var i = 0; i < 13; i++) {
      canvas.save();
      canvas.translate(45.0 + i * 25, 48.0 + (i % 3) * 30);
      canvas.rotate(i.isEven ? .4 : -.65);
      block(
        const Rect.fromLTWH(0, 0, 4, 22),
        [
          const Color(0xFFFFCA42),
          const Color(0xFF8A68BB),
          const Color(0xFF286553),
        ][i % 3],
      );
      canvas.restore();
    }
    paint.color = const Color(0xFF222222);
    final bat = Path()
      ..moveTo(28, 115)
      ..quadraticBezierTo(55, 85, 86, 104)
      ..lineTo(98, 91)
      ..lineTo(110, 105)
      ..quadraticBezierTo(145, 85, 160, 116)
      ..quadraticBezierTo(133, 104, 122, 133)
      ..quadraticBezierTo(98, 120, 78, 137)
      ..quadraticBezierTo(64, 109, 28, 115);
    canvas.drawPath(bat, paint);
    paint.color = const Color(0xFFFDFDFC);
    final ghost = Path()
      ..moveTo(134, 188)
      ..lineTo(134, 111)
      ..cubicTo(134, 44, 243, 44, 243, 111)
      ..lineTo(243, 188)
      ..lineTo(222, 176)
      ..lineTo(201, 191)
      ..lineTo(179, 176)
      ..lineTo(157, 191)
      ..close();
    canvas.drawShadow(ghost, Colors.black, 5, false);
    canvas.drawPath(ghost, paint);
    paint.color = Colors.black;
    canvas.drawOval(const Rect.fromLTWH(159, 111, 13, 20), paint);
    canvas.drawOval(const Rect.fromLTWH(204, 111, 13, 20), paint);
    canvas.drawOval(const Rect.fromLTWH(182, 140, 14, 18), paint);
    final cat = Path()
      ..moveTo(266, 172)
      ..lineTo(263, 112)
      ..lineTo(280, 130)
      ..quadraticBezierTo(299, 120, 317, 130)
      ..lineTo(335, 112)
      ..lineTo(333, 173)
      ..quadraticBezierTo(303, 198, 266, 172);
    canvas.drawPath(cat, paint);
    paint.color = const Color(0xFFFFCA42);
    canvas.drawOval(const Rect.fromLTWH(280, 148, 12, 6), paint);
    canvas.drawOval(const Rect.fromLTWH(309, 148, 12, 6), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CreaturePainter oldDelegate) => false;
}
