import 'package:flutter/material.dart';
import '../services/university_service.dart';
import '../models/university_model.dart';

// halaman utama untuk menampilkan daftar universitas
class UniversityPage extends StatefulWidget {
  const UniversityPage({super.key});

  @override
  State<UniversityPage> createState() => _UniversityPageState();
}

class _UniversityPageState extends State<UniversityPage> {
  // future untuk menyimpan hasil pemanggilan api universitas
  late Future<List<University>> universities;

  @override
  void initState() {
    super.initState();
    // memanggil api untuk mengambil data universitas saat halaman pertama kali dibuat
    universities = UniversityService().fetchUniversities();
  }

  @override
  Widget build(BuildContext context) {
    // menggunakan futurebuilder untuk menunggu data universitas selesai diambil
    return FutureBuilder<List<University>>(
      future: universities,
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

        // jika data berhasil diterima
        return ListView(
          children: snapshot.data!
              .map(
                (u) => Card(
                  child: ListTile(
                    // nama universitas
                    title: Text(u.name),
                    // website universitas
                    subtitle: Text(u.web),
                  ),
                ),
              )
              .toList(), // ubah list universitas menjadi list widget
        );
      },
    );
  }
}
