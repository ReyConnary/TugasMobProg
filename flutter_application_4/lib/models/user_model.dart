// mengimpor paket hive untuk menyimpan data secara lokal
import 'package:hive/hive.dart';

// mengimpor pustaka untuk konversi teks ke bytes
import 'dart:convert';

// mengimpor pustaka untuk membuat hash menggunakan algoritma sha256
import 'package:crypto/crypto.dart';

// bagian ini digunakan agar hive dapat menghasilkan kode tambahan secara otomatis
part 'user_model.g.dart';

// anotasi yang menandai bahwa kelas ini adalah model yang akan disimpan di hive
// typeId harus unik, di sini nilainya 1 karena berbeda dengan model task
@HiveType(typeId: 1)
class User extends HiveObject {
  // menyimpan nama pengguna
  @HiveField(0)
  String username;

  // menyimpan hash dari password, bukan password asli
  @HiveField(1)
  String passwordHash;

  // konstruktor untuk menginisialisasi username dan password hash
  User({required this.username, required this.passwordHash});

  // fungsi statis untuk mengubah password menjadi hash
  // langkahnya: ubah password ke bytes, lalu buat hash sha256, lalu ubah hasilnya ke string
  static String hashPassword(String password) {
    final bytes = utf8.encode(password); // ubah password menjadi bytes
    final digest = sha256.convert(bytes); // buat hash sha256
    return digest.toString(); // ubah hash menjadi string
  }

  // fungsi untuk memeriksa apakah password yang dimasukkan cocok dengan hash yang tersimpan
  bool checkPassword(String password) {
    return passwordHash == hashPassword(password); // bandingkan hasil hash
  }
}
