class Novel {
  final int id;
  final String name;
  final String cover;
  final String description;
  final String createdAt;

  Novel({
    required this.id,
    required this.name,
    required this.cover,
    required this.description,
    required this.createdAt,
  });

  static Novel fromJson(Map<String, dynamic> data) {
    return Novel(
        id: data['id'],
        name: data['name'],
        cover: data['cover'],
        description: data['description'],
        createdAt: data['createdAt']);
  }
}
