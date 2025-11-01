import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../models/news_model.dart';

// halaman utama untuk menampilkan daftar berita
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // future untuk menyimpan hasil pengambilan data berita dari api
  late Future<List<News>> news;

  @override
  void initState() {
    super.initState();
    // memanggil api untuk mengambil berita saat halaman pertama kali dibuat
    news = NewsService().fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    // menggunakan futurebuilder untuk menunggu data berita selesai diambil
    return FutureBuilder<List<News>>(
      future: news,
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
                (n) => Card(
                  child: ListTile(
                    // judul berita
                    title: Text(n.title),
                    // deskripsi berita
                    subtitle: Text(n.description),
                  ),
                ),
              )
              .toList(), // ubah list news menjadi list widget
        );
      },
    );
  }
}
