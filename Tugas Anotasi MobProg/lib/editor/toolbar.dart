import 'package:flutter/material.dart';
import 'models.dart';

/// Toolbar untuk memilih mode, warna, dan ketebalan anotasi
class AnnotationToolbar extends StatelessWidget {
  /// Mode anotasi yang sedang aktif (view/draw/marker/erase)
  final AnnotationMode currentMode;

  /// Warna garis yang dipakai untuk menggambar
  final Color currentColor;

  /// Ketebalan garis yang dipakai untuk menggambar
  final double currentStroke;

  /// Callback ketika mode diganti
  final ValueChanged<AnnotationMode> onModeChanged;

  /// Callback ketika warna diganti
  final ValueChanged<Color> onColorChanged;

  /// Callback ketika ketebalan garis diganti
  final ValueChanged<double> onStrokeChanged;

  const AnnotationToolbar({
    super.key,
    required this.currentMode,
    required this.currentColor,
    required this.currentStroke,
    required this.onModeChanged,
    required this.onColorChanged,
    required this.onStrokeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Tombol mode: hanya melihat (pan/zoom)
        IconButton(
          icon: Icon(
            Icons.pan_tool,
            color: currentMode == AnnotationMode.view ? Colors.blue : null,
          ),
          onPressed: () => onModeChanged(AnnotationMode.view),
        ),

        // Tombol mode: menggambar bebas
        IconButton(
          icon: Icon(
            Icons.edit,
            color: currentMode == AnnotationMode.draw ? Colors.blue : null,
          ),
          onPressed: () => onModeChanged(AnnotationMode.draw),
        ),

        // Tombol mode: menambahkan marker/titik
        IconButton(
          icon: Icon(
            Icons.add_location,
            color: currentMode == AnnotationMode.marker ? Colors.blue : null,
          ),
          onPressed: () => onModeChanged(AnnotationMode.marker),
        ),

        // Tombol mode: menghapus anotasi
        IconButton(
          icon: Icon(
            Icons.remove_circle,
            color: currentMode == AnnotationMode.erase ? Colors.blue : null,
          ),
          onPressed: () => onModeChanged(AnnotationMode.erase),
        ),

        // Tombol untuk memilih warna
        IconButton(
          icon: const Icon(Icons.color_lens),
          onPressed: () async {
            // Pilihan warna sederhana
            final colors = [
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.yellow,
              Colors.white,
              Colors.black,
            ];

            // Dialog pemilih warna
            final chosen = await showDialog<Color>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Pilih Warna"),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: colors
                      .map(
                        (c) => GestureDetector(
                          onTap: () => Navigator.pop(context, c),
                          child: CircleAvatar(backgroundColor: c),
                        ),
                      )
                      .toList(),
                ),
              ),
            );

            if (chosen != null) onColorChanged(chosen);
          },
        ),

        // Slider untuk mengatur ketebalan garis
        Expanded(
          child: Slider(
            min: 1,
            max: 10,
            value: currentStroke,
            onChanged: onStrokeChanged,
          ),
        ),
      ],
    );
  }
}
