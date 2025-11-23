import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'stok_page.dart';
import 'halaman_transaksi.dart';
import 'riwayat_transaksi.dart';
import 'histori.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? dashboardData;
  bool loading = true;

  final NumberFormat rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost/iventory_db/get_dashboard_data.php"),
      );

      if (response.statusCode == 200) {
        setState(() {
          dashboardData = json.decode(response.body);
          loading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "📊 Aplikasi Manajemen Inventaris",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.black : Colors.teal,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
            ),
            onPressed: () {
              InventoryApp.of(context)!.toggleTheme();
            },
          ),

          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
            offset: const Offset(0, 56),
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'stok',
                child: ListTile(
                  leading: const Icon(Icons.inventory_2, color: Colors.teal),
                  title: const Text('Stok Barang'),
                  subtitle: const Text('Kelola data barang'),
                ),
              ),
              PopupMenuItem(
                value: 'transaksi',
                child: ListTile(
                  leading: const Icon(Icons.swap_horiz, color: Colors.indigo),
                  title: const Text('Transaksi'),
                  subtitle: const Text('Tambah / lihat transaksi'),
                ),
              ),
              PopupMenuItem(
                value: 'riwayat',
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.purple),
                  title: const Text('Riwayat Transaksi'),
                  subtitle: const Text('Log transaksi sebelumnya'),
                ),
              ),
              PopupMenuItem(
                value: 'histori',
                child: ListTile(
                  leading: const Icon(Icons.list_alt, color: Colors.brown),
                  title: const Text('Histori Barang'),
                  subtitle: const Text('Detail histori perubahan stok'),
                ),
              ),
            ],

            icon: GestureDetector(
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StokPage()),
                );
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HalamanTransaksi()),
                  );
                }
              },
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! > 300) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RiwayatTransaksi()),
                  );
                }
              },
              onDoubleTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoriPage()),
                );
              },
              child: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData == null
              ? const Center(child: Text("Gagal memuat data"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: DefaultTextStyle(
                    style: TextStyle(color: textColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3.8,
                          children: [
                            _buildSummaryCard(
                              title: "Total Barang",
                              value: "${dashboardData!['total_barang']}",
                              color: Colors.teal,
                              icon: Icons.inventory_2,
                            ),
                            _buildSummaryCard(
                              title: "Barang Masuk Hari Ini",
                              value:
                                  "${dashboardData!['barang_masuk_hari_ini']}",
                              color: Colors.blue,
                              icon: Icons.download,
                            ),
                            _buildSummaryCard(
                              title: "Barang Keluar Hari Ini",
                              value:
                                  "${dashboardData!['barang_keluar_hari_ini']}",
                              color: Colors.red,
                              icon: Icons.upload,
                            ),
                            _buildSummaryCard(
                              title: "Nilai Total Stok",
                              value: rupiahFormat.format(
                                double.tryParse(
                                      dashboardData!['nilai_stok'].toString(),
                                    ) ??
                                    0,
                              ),
                              color: Colors.orange,
                              icon: Icons.attach_money,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Text(
                          "⚠️ Stok Hampir Habis",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),

                        ..._buildLowStockList(
                          dashboardData!['stok_hampir_habis'],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(title),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'stok':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const StokPage()));
        break;

      case 'transaksi':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const HalamanTransaksi()));
        break;

      case 'riwayat':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const RiwayatTransaksi()));
        break;

      case 'histori':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const HistoriPage()));
        break;
    }
  }

  List<Widget> _buildLowStockList(List<dynamic> lowStock) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black87;

    if (lowStock.isEmpty) {
      return [
        Text("Semua stok aman ✅", style: TextStyle(color: textColor)),
      ];
    }

    return lowStock.map((item) {
      final stok = item['jum_barang'] ?? item['stok'] ?? 0;
      return Card(
        child: ListTile(
          leading: const Icon(Icons.warning, color: Colors.redAccent),
          title: Text(
            item['nama_barang'] ?? 'Tidak diketahui',
          ),
          subtitle: Text("Sisa stok: $stok"),
        ),
      );
    }).toList();
  }
}
