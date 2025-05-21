class SubCategory {
  int id;
  String title;
  int generalCategoryId;
  int? parentCategoryId;

  SubCategory({
    required this.id,
    required this.title,
    required this.generalCategoryId,
    required this.parentCategoryId,
  });

  factory SubCategory.fromJsonObject(Map<String, dynamic> jsonObject) {
    return SubCategory(
      id: jsonObject['id'],
      title: jsonObject['title'],
      generalCategoryId: jsonObject['general_category'],
      parentCategoryId: jsonObject['parent_category'],
    );
  }
}
