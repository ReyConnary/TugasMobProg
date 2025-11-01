import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

class CountryService {
  static const String url =
      'https://restcountries.com/v3.1/independent?status=true';

// Mengambil data country dari api. Future dipake karena kita menunggu untuk datanya load dari url (Async pun sama)
  Future<List<Country>> fetchCountries() async {
    final response = await http.get(Uri.parse(url)); //Beri request http get ke si url

// Jika status code = 200 (berhasil) maka pertama konversi sumber json menjadi dart list yg tersimpan di data
// Untuk semua item di dalam list data, buat 1 objek country dari country.fromjson yang berasal dari country_model
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
