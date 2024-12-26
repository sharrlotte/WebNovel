class Novel {
  final int id;
  final String name;
  final String cover;
  final String description;
  final String createdAt;
  final String author;
  final String status;

  Novel({
    required this.id,
    required this.name,
    required this.cover,
    required this.author,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  static Novel fromJson(Map<String, dynamic> data) {
    return Novel(
        id: data['id'],
        name: data['name'],
        cover: data['cover'],
        description: data['description'],
        author: data['author'],
        createdAt: data['createdAt'],
        status: data['status'] ?? 'COMPLETED');
  }
}
