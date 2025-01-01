class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  static Category fromJson(Map<String, dynamic> data) {
    return Category(id: data['id'], name: data['name']);
  }
}
