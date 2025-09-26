import 'package:flutter/material.dart';
import 'editor/editor_page.dart';

/// Entry point aplikasi
void main() {
  runApp(const AnnotationApp());
}

/// Widget utama aplikasi
class AnnotationApp extends StatelessWidget {
  const AnnotationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery Zoom & Annotate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Halaman utama -> EditorPage
      home: const EditorPage(),
    );
  }
}
