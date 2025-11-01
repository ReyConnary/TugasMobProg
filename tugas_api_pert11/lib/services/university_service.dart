import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/university_model.dart';

class UniversityService {
  static const String url =
      'http://universities.hipolabs.com/search?country=Indonesia';

  Future<List<University>> fetchUniversities() async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((u) => University.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load universities');
    }
  }
}
