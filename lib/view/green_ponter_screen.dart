
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class GreenPainter extends CustomPainter {
  final List<Face> faces;

  GreenPainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (final face in faces) {
      final faceRect = Rect.fromLTRB(
        face.boundingBox.left,
        face.boundingBox.top,
        face.boundingBox.right,
        face.boundingBox.bottom,
      );
      canvas.drawRect(faceRect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}