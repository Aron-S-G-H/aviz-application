class Category {
  int id;
  String title;

  Category({required this.id, required this.title});

  factory Category.fromJsonObject(Map<String, dynamic> jsonObject) {
    return Category(id: jsonObject['id'], title: jsonObject['title']);
  }
}