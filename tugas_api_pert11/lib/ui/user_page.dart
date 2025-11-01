import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

// halaman utama untuk menampilkan daftar user
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // future untuk menyimpan hasil pemanggilan api user
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    // memanggil api untuk mengambil data user saat halaman pertama kali dibuat
    users = UserService().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    // menggunakan futurebuilder untuk menunggu data user selesai diambil
    return FutureBuilder<List<User>>(
      future: users,
      builder: (context, snapshot) {
        // jika future masih menunggu hasil
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(), // tampilkan loading spinner
          );
        } 
        // jika terjadi error saat mengambil data
        else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()), // tampilkan pesan error
          );
        } 
        // jika tidak ada data yang diterima
        else if (!snapshot.hasData) {
          return const Center(
            child: Text('no data'), // tampilkan teks no data
          );
        }

        // jika data berhasil diterima
        return ListView(
          children: snapshot.data!
              .map(
                (u) => Card(
                  child: ListTile(
                    // nama user
                    title: Text(u.name),
                    // email user
                    subtitle: Text(u.email),
                  ),
                ),
              )
              .toList(), // ubah list user menjadi list widget
        );
      },
    );
  }
}
