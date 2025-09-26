import 'package:flutter/material.dart';

/// Mode anotasi yang tersedia untuk editor
enum AnnotationMode {
  /// Hanya melihat gambar (tanpa interaksi anotasi)
  view,

  /// Menambahkan marker (titik/garis kecil)
  marker,

  /// Menggambar bebas (freehand draw)
  draw,

  /// Menghapus anotasi dengan tap/drag
  erase,
}

/// Representasi sebuah anotasi (gambar di atas image)
class Annotation {
  /// Titik-titik yang membentuk garis/anotasi
  final List<Offset> points;

  /// Warna garis anotasi
  final Color color;

  /// Ketebalan garis
  final double strokeWidth;

  /// Constructor untuk membuat anotasi baru
  Annotation({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}
