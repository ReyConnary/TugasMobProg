// mengimpor pustaka untuk mengakses file dan direktori lokal
import 'dart:io';

// mengimpor pustaka flutter untuk membangun tampilan antarmuka pengguna
import 'package:flutter/material.dart';

// mengimpor model task agar bisa digunakan di halaman ini
import 'package:flutter_application_4/models/task_model.dart';

// mengimpor model user agar bisa digunakan di proses login dan registrasi
import 'package:flutter_application_4/models/user_model.dart';

// mengimpor pustaka hive untuk penyimpanan lokal
import 'package:hive/hive.dart';

// mengimpor helper box hive (biasanya berisi fungsi pembuka box data)
import '../hive_boxes.dart';

// mengimpor halaman todo yang akan dituju setelah login atau registrasi berhasil
import 'todo_page.dart';

// mendefinisikan widget stateful untuk halaman login dan registrasi
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// state dari halaman login
class _LoginPageState extends State<LoginPage> {
  // controller untuk input teks username dan password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // menentukan apakah sedang di mode login atau signup
  bool _isLoginMode = true;

  // membuka box task berdasarkan nama pengguna
  Future<void> _openTaskBox(String username) async {
    final boxName = 'tasks_$username'; // nama box unik per pengguna
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      if (box is! Box<Task>) await box.close(); // jika bukan box task, tutup
    }
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<Task>(boxName); // buka box task pengguna
    }
  }

  // menyimpan data user ke file eksternal (users.txt)
  Future<void> _saveUserToExternal(User user) async {
    final directory = Directory.current; // ambil direktori saat ini
    final file = File('${directory.path}/users.txt'); // buat file users.txt

    // tulis username dan hash password dalam satu baris
    final line = '${user.username}:${user.passwordHash}\n';
    await file.writeAsString(line, mode: FileMode.append); // tambahkan ke file
  }

  // fungsi utama untuk login atau daftar
  void _submit() async {
    final usersBox = HiveBoxes.getUsersBox(); // ambil box penyimpanan user
    final username = _usernameController.text.trim(); // hapus spasi
    final password = _passwordController.text.trim();

    // validasi input tidak boleh kosong
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan password tidak boleh kosong')),
      );
      return;
    }

    // cari apakah user sudah ada di box
    final existingUser = usersBox.values.firstWhere(
      (u) => u.username == username,
      orElse: () => User(username: '', passwordHash: ''),
    );

    // mode login
    if (_isLoginMode) {
      // jika user tidak ditemukan
      if (existingUser.username.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User tidak ditemukan')),
        );
        return;
      }

      // jika password salah
      if (!existingUser.checkPassword(password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password salah')),
        );
        return;
      }

      // buka box task dan pindah ke halaman todo
      await _openTaskBox(username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TodoPage(username: username)),
      );

    // mode daftar akun baru
    } else {
      // jika username sudah digunakan
      if (existingUser.username.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username sudah digunakan')),
        );
        return;
      }

      // buat user baru dengan password yang di-hash
      final newUser = User(
        username: username,
        passwordHash: User.hashPassword(password),
      );

      // simpan user ke hive dan file eksternal
      await usersBox.add(newUser);
      await _saveUserToExternal(newUser);

      // buka box task untuk user baru
      await _openTaskBox(username);

      // tampilkan notifikasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Akun "$username" berhasil dibuat!')),
      );

      // arahkan ke halaman todo
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TodoPage(username: username)),
      );
    }
  }

  // membangun tampilan halaman login atau registrasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Login' : 'Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // input username
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // input password
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // menyembunyikan karakter password
            ),
            const SizedBox(height: 20),

            // tombol login atau daftar
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLoginMode ? 'Masuk' : 'Daftar'),
            ),
            const SizedBox(height: 10),

            // tombol untuk berganti mode (login <-> daftar)
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoginMode = !_isLoginMode;
                });
              },
              child: Text(
                _isLoginMode
                    ? 'Belum punya akun? Daftar di sini'
                    : 'Sudah punya akun? Login di sini',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
