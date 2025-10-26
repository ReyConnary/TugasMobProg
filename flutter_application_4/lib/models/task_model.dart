// mengimpor paket hive untuk menyimpan data lokal secara efisien
import 'package:hive/hive.dart';

// bagian ini digunakan agar hive dapat menghasilkan kode tambahan secara otomatis
// file 'task_model.g.dart' akan dibuat ketika menjalankan perintah build_runner
part 'task_model.g.dart';

// anotasi untuk memberi tahu hive bahwa kelas ini adalah tipe data yang akan disimpan
// typeId harus unik untuk setiap model
@HiveType(typeId: 0)
class Task extends HiveObject {
  // setiap @HiveField menandai kolom yang akan disimpan dalam database hive
  // angka di dalamnya adalah indeks kolom yang tidak boleh diubah setelah digunakan
  @HiveField(0)
  String taskName; // nama tugas

  @HiveField(1)
  DateTime createdDate; // tanggal saat tugas dibuat

  @HiveField(2)
  DateTime deadline; // batas waktu penyelesaian tugas

  @HiveField(3)
  bool isDone; // status apakah tugas sudah selesai atau belum

  // konstruktor untuk menginisialisasi semua properti kelas
  // parameter 'required' berarti nilai tersebut wajib diisi
  // nilai default untuk isDone adalah false
  Task({
    required this.taskName,
    required this.createdDate,
    required this.deadline,
    this.isDone = false,
  });
}
