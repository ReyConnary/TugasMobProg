import 'package:flutter/material.dart';
import 'ui/user_page.dart';
import 'ui/news_page.dart';
import 'ui/university_page.dart';
import 'ui/country_page.dart';
import 'ui/product_page.dart';

// titik masuk aplikasi flutter
void main() {
  runApp(const MyApp());
}

// widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hilangkan label debug
      title: 'public api viewer', // judul aplikasi
      theme: ThemeData(primarySwatch: Colors.indigo), // tema utama
      home: const HomePage(), // halaman awal aplikasi
    );
  }
}

// halaman home yang berisi tab untuk tiap kategori api
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // jumlah tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('public api viewer'),
          bottom: const TabBar(
            isScrollable: true, // jika tab terlalu banyak, bisa digeser
            tabs: [
              Tab(text: 'Users'), // tab untuk user
              Tab(text: 'News'), // tab untuk news
              Tab(text: 'Universities'), // tab untuk universitas
              Tab(text: 'Countries'), // tab untuk negara
              Tab(text: 'Products'), // tab untuk produk
            ],
          ),
        ),
        // body berisi konten tiap tab
        body: const TabBarView(
          children: [
            UserPage(), // halaman user
            NewsPage(), // halaman news
            UniversityPage(), // halaman universitas
            CountryPage(), // halaman negara
            ProductListPage(), // halaman produk
          ],
        ),
      ),
    );
  }
}
