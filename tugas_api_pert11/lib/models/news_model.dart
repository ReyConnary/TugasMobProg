// Buat constructor/kerangka untuk objek yang akan diisi nanti
class News {
  final String title;
  final String description;

  News({required this.title, required this.description});

// Konversi data json jadi format yang cocok untuk diload ke objek
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
    );
  }
}
