import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

// Gunakan api khusus untuk url tertentu
class NewsService {
  static const String apiKey = 'abc00025d41547b292fc7f31b8b5032f';
  static const String url =
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

  Future<List<News>> fetchNews() async {
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final List articles = jsonDecode(res.body)['articles']; //hanya ambil elemen articles lalu simpan ke articles
      return articles.map((a) => News.fromJson(a)).toList(); //buat 1 objek news untuk setiap item yang berada di articles
    } else {
      throw Exception('Failed to load news');
    }
  }
}
