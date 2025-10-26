import 'dart:io'; // digunakan untuk operasi file dan direktori di sistem lokal
import 'package:flutter/foundation.dart' show kIsWeb; // digunakan untuk mendeteksi apakah aplikasi berjalan di web
import 'package:flutter/material.dart'; // pustaka utama flutter untuk membangun ui
import 'package:hive_flutter/hive_flutter.dart'; // integrasi hive dengan flutter
import 'models/task_model.dart'; // mengimpor model task agar bisa diregistrasi ke hive
import 'models/user_model.dart'; // mengimpor model user agar bisa diregistrasi ke hive
import 'pages/login_page.dart'; // mengimpor halaman login yang akan menjadi halaman awal

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // memastikan binding flutter diinisialisasi sebelum menjalankan kode async

  // inisialisasi hive tergantung platform
  if (kIsWeb) {
    // jika berjalan di web, gunakan penyimpanan browser
    await Hive.initFlutter();
  } else {
    // jika berjalan di desktop, gunakan folder lokal khusus
    const hivePath = r'C:\Todo'; // menentukan direktori penyimpanan hive
    final dir = Directory(hivePath);
    if (!await dir.exists()) {
      await dir.create(recursive: true); // buat folder jika belum ada
    }

    // gunakan Hive.init() bukan Hive.initFlutter() untuk direktori custom
    Hive.init(hivePath);
    print('✅ Hive initialized at: $hivePath'); // log lokasi penyimpanan hive
  }

  // registrasi adapter agar hive tahu cara menyimpan dan membaca objek task dan user
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(UserAdapter());

  // membuka box untuk menyimpan data user
  await Hive.openBox<User>('users');

  // menjalankan aplikasi utama
  runApp(const MyApp());
}

// kelas utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // menghilangkan label debug di pojok layar
      title: 'Todo List Hive', // judul aplikasi
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // tema dengan warna utama biru
        useMaterial3: true, // mengaktifkan gaya material design 3
      ),
      home: const LoginPage(), // halaman awal diarahkan ke login
    );
  }
}
