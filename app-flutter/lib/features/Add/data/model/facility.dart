class Facility {
  int id;
  String title;

  Facility({required this.id, required this.title});

  factory Facility.fromJsonObject(Map<String, dynamic> jsonObject) {
    return Facility(id: jsonObject['id'], title: jsonObject['title']);
  }
}
