// Buat class utk diisi atribut yang sesuai
// final berarti nilai tidak bisa diubah setelah suatu object dibuat
class Country {
  final String name;
  final String region;
  final String flagUrl;
  final int population;

// Constructor utk membuat objek baru (Kerangka yg akan diisi daging)
  Country({
    required this.name,
    required this.region,
    required this.flagUrl,
    required this.population,
  });

// Ubah format yang sumbernya json menjadi format yang cocok untuk dijadikan object
// ?? itu intinya atribut itu bakal diisi apa jika null/kosong
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']?['common'] ?? 'Unknown',
      region: json['region'] ?? 'Unknown',
      flagUrl: json['flags']?['png'] ?? '',
      population: json['population'] ?? 0,
    );
  }
}
