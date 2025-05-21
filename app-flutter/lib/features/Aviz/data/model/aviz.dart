class Aviz {
  int id;
  String title;
  String description;
  List<String> images;
  int price;
  int? pricePerMeter;
  int? totalArea;
  int? floor;
  int? rooms;
  int? yearOfConstruction;
  String? createdAt;
  List<String>? facilities;

  Aviz({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
    this.pricePerMeter,
    this.totalArea,
    this.floor,
    this.rooms,
    this.yearOfConstruction,
    this.createdAt,
    this.facilities,
  });

  factory Aviz.fromJsonObject(Map<String, dynamic> jsonObject) {
    return Aviz(
      id: jsonObject['id'],
      title: jsonObject['title'],
      description: jsonObject['description'],
      images: List<String>.from(jsonObject['poster_links']),
      price: jsonObject['price'],
      pricePerMeter: jsonObject['price_per_meter'],
      totalArea: jsonObject['total_area'],
      floor: jsonObject['floor'],
      rooms: jsonObject['rooms'],
      yearOfConstruction: jsonObject['year_of_construction'],
      createdAt: jsonObject['created_at'],
      facilities: List<String>.from(jsonObject['facilities'] ?? []),
    );
  }
}