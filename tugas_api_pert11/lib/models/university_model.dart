class University {
  final String name;
  final String web;

  University({required this.name, required this.web});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      web: (json['web_pages'] as List).first, //ambil url website pertama dari json
    );
  }
}
