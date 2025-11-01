import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

// halaman utama untuk menampilkan daftar produk
class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // future untuk menyimpan hasil pemanggilan api produk
  late Future<List<Product>> futureProducts;

  // service untuk mengambil data produk dari api
  final productService = ProductService();

  @override
  void initState() {
    super.initState();
    // memanggil api untuk mengambil produk saat halaman pertama kali dibangun
    futureProducts = productService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // menggunakan futurebuilder untuk menunggu data produk selesai diambil
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
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
              child: Text('error: ${snapshot.error}'), // tampilkan pesan error
            );
          } 
          // jika tidak ada data produk
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('tidak ada produk.'), // tampilkan teks no data
            );
          } 
          // jika data berhasil diterima
          else {
            final products = snapshot.data!;
            // menampilkan daftar produk menggunakan listview.builder
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                // setiap item dibungkus dengan card
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    // gambar produk
                    leading: Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    // nama produk
                    title: Text(product.title),
                    // harga produk
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
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
