import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:html' as html;
import 'package:image_picker/image_picker.dart';

import 'models.dart';
import 'painter.dart';
import 'toolbar.dart';

/// Halaman utama untuk Editor (Zoom, Anotasi, Simpan gambar)
class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  Uint8List? _imageBytes; // Menyimpan gambar yang dipilih
  final List<Annotation> _annotations = []; // Semua anotasi
  AnnotationMode _mode = AnnotationMode.view; // Mode editor
  Color _color = Colors.red; // Warna default untuk anotasi
  double _stroke = 3.0; // Ketebalan garis
  GlobalKey _repaintKey = GlobalKey(); // Untuk export/simpan

  List<Offset> _currentPoints = []; // Titik-titik garis saat sedang digambar

  /// Tambah titik baru saat menggambar
  void _addPoint(Offset point) {
    setState(() {
      _currentPoints.add(point);
    });
  }

  /// Akhiri proses menggambar dan simpan ke list anotasi
  void _endDrawing() {
    if (_currentPoints.isNotEmpty) {
      setState(() {
        _annotations.add(
          Annotation(
            points: List.from(_currentPoints),
            color: _color,
            strokeWidth: _stroke,
          ),
        );
        _currentPoints.clear();
      });
    }
  }

  /// Pilih gambar dari galeri (Web / Mobile)
  Future<void> _pickImage() async {
    try {
      if (kIsWeb) {
        // ---- Pilih gambar di Browser ----
        final input = html.FileUploadInputElement()..accept = 'image/*';
        input.click();

        await input.onChange.first;
        if (input.files != null && input.files!.isNotEmpty) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(input.files!.first);
          await reader.onLoad.first;
          setState(() {
            _imageBytes = reader.result as Uint8List;
          });
        }
      } else {
        // ---- Pilih gambar dari galeri (Android/iOS) ----
        final ImagePicker picker = ImagePicker();
        await picker.pickImage(source: ImageSource.gallery);
        // (Anda bisa simpan hasil picker ke _imageBytes bila perlu)
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  /// Simpan gambar hasil anotasi (Web / Mobile)
  Future<void> _saveImage() async {
    try {
      // Render widget ke gambar
      RenderRepaintBoundary boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      if (kIsWeb) {
        // ---- Simpan di browser ----
        final blob = html.Blob([pngBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        // Buat link tersembunyi untuk memicu download
        final anchor = html.AnchorElement(href: url)
          ..style.display = 'none'
          ..download = "annotated_image.png";
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);

        // Hapus URL blob setelah selesai
        html.Url.revokeObjectUrl(url);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image downloaded")),
        );
      } else {
        // ---- Simpan di Android / iOS ----
        if (await Permission.storage.request().isGranted) {
          await ImageGallerySaver.saveImage(pngBytes);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image saved to gallery")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save: $e")),
      );
    }
  }

  /// Kontrol zoom / panning
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;

  /// Double tap untuk zoom in / reset
  void _handleDoubleTap(TapDownDetails details) {
    if (_currentScale == 1.0) {
      // Zoom in
      _currentScale = 2.0;
      final position = details.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(_currentScale);
    } else {
      // Reset zoom
      _currentScale = 1.0;
      _transformationController.value = Matrix4.identity();
    }
  }

  /// Widget gambar utama
  Widget _buildImage() {
    if (_imageBytes != null) {
      return Image.memory(_imageBytes!, fit: BoxFit.contain);
    } else {
      return const Center(
        child: Text("No image selected"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        title: const Text("Gallery Zoom & Annotate"),
        actions: [
          IconButton(onPressed: _pickImage, icon: const Icon(Icons.image)),
          IconButton(onPressed: _saveImage, icon: const Icon(Icons.save)),
        ],
      ),

      // ---- Body ----
      body: Column(
        children: [
          // Toolbar untuk mode, warna, ketebalan
          AnnotationToolbar(
            currentMode: _mode,
            currentColor: _color,
            currentStroke: _stroke,
            onModeChanged: (m) => setState(() => _mode = m),
            onColorChanged: (c) => setState(() => _color = c),
            onStrokeChanged: (s) => setState(() => _stroke = s),
          ),

          // ---- Area gambar + anotasi ----
          Expanded(
            child: GestureDetector(
              onDoubleTapDown: _handleDoubleTap,
              onDoubleTap: () {},

              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 1.0,
                maxScale: 4.0,

                child: RepaintBoundary(
                  key: _repaintKey,

                  child: (_mode == AnnotationMode.view)
                      // ---- Mode view (hanya zoom & pan) ----
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            _buildImage(),
                            CustomPaint(
                              size: Size.infinite,
                              painter: AnnotationPainter(_annotations),
                            ),
                          ],
                        )

                      // ---- Mode anotasi aktif ----
                      : GestureDetector(
                          onPanUpdate: (details) {
                            if (_mode == AnnotationMode.draw) {
                              _addPoint(details.localPosition);
                            }
                          },
                          onPanEnd: (details) {
                            if (_mode == AnnotationMode.draw) {
                              _endDrawing();
                            }
                          },
                          onTapDown: (details) {
                            if (_mode == AnnotationMode.marker) {
                              // Tambah marker
                              setState(() {
                                _annotations.add(
                                  Annotation(
                                    points: [
                                      details.localPosition,
                                      details.localPosition
                                    ],
                                    color: _color,
                                    strokeWidth: _stroke,
                                  ),
                                );
                              });
                            } else if (_mode == AnnotationMode.erase) {
                              // Hapus anotasi dekat tap
                              setState(() {
                                _annotations.removeWhere((a) => a.points.any(
                                    (p) => (p - details.localPosition).distance <
                                        10));
                              });
                            }
                          },

                          // ---- Render gambar + anotasi ----
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildImage(),
                              CustomPaint(
                                size: Size.infinite,
                                painter: AnnotationPainter([
                                  ..._annotations,
                                  if (_currentPoints.isNotEmpty)
                                    Annotation(
                                      points: _currentPoints,
                                      color: _color,
                                      strokeWidth: _stroke,
                                    )
                                ]),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
