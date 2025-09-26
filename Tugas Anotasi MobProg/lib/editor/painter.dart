import 'package:flutter/material.dart';
import 'models.dart';

/// CustomPainter untuk menggambar anotasi di atas gambar.
/// Menggunakan data dari List<Annotation> (lihat models.dart).
class AnnotationPainter extends CustomPainter {
  /// List anotasi yang akan digambar
  final List<Annotation> annotations;

  AnnotationPainter(this.annotations);

  @override
  void paint(Canvas canvas, Size size) {
    // Loop setiap anotasi
    for (var annotation in annotations) {
      // Konfigurasi gaya garis untuk anotasi
      final paint = Paint()
        ..color = annotation.color
        ..strokeWidth = annotation.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Gambar garis antar titik (freehand atau marker)
      for (int i = 0; i < annotation.points.length - 1; i++) {
        if (annotation.points[i] != Offset.zero &&
            annotation.points[i + 1] != Offset.zero) {
          canvas.drawLine(annotation.points[i], annotation.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant AnnotationPainter oldDelegate) {
    // Repaint bila list anotasi berubah
    return oldDelegate.annotations != annotations;
  }
}
