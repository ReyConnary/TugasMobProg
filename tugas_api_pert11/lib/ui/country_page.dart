import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/country_service.dart';

// halaman utama untuk menampilkan daftar negara
class CountryPage extends StatefulWidget {
  const CountryPage({Key? key}) : super(key: key);

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  // service untuk mengambil data negara dari api
  final countryService = CountryService();
  
  // future yang akan menyimpan hasil pemanggilan api
  late Future<List<Country>> futureCountries;

  @override
  void initState() {
    super.initState();
    // memanggil api saat halaman pertama kali dibangun
    futureCountries = countryService.fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // menggunakan futurebuilder untuk menunggu data selesai diambil
      body: FutureBuilder<List<Country>>(
        future: futureCountries,
        builder: (context, snapshot) {
          // jika future masih dalam proses menunggu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // tampilkan loading spinner
            );
          } 
          // jika terjadi error saat mengambil data
          else if (snapshot.hasError) {
            return Center(
              child: Text('error: ${snapshot.error}'), // tampilkan pesan error
            );
          } 
          // jika tidak ada data yang diterima
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('no data found'), // tampilkan teks no data
            );
          } 
          // jika data berhasil diterima
          else {
            final countries = snapshot.data!;
            // menampilkan daftar negara menggunakan listview.builder
            return ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final c = countries[index];
                // setiap item dalam daftar dibungkus dengan card
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 12),
                  child: ListTile(
                    // gambar bendera negara
                    leading: Image.network(c.flagUrl, width: 50, height: 30),
                    // nama negara
                    title: Text(c.name),
                    // region dan populasi negara
                    subtitle: Text('${c.region} — ${c.population} people'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
