import 'package:frontend/models/category.dart';
import 'package:frontend/utils.dart';

class Novel {
  final int id;
  final String name;
  final String cover;
  final String description;
  final String createdAt;
  final String author;
  final String status;
  bool isFollowing;
  final List<Category> categories;

  Novel(
      {required this.id,
      required this.name,
      required this.cover,
      required this.author,
      required this.description,
      required this.createdAt,
      required this.status,
      required this.categories,
      required this.isFollowing});

  static Novel fromJson(Map<String, dynamic> data) {
    return Novel(
        id: data['id'],
        name: data['name'],
        cover: data['cover'],
        description: data['description'],
        author: data['author'],
        createdAt: data['createdAt'],
        status: data['status'] ?? 'COMPLETED',
        isFollowing: data['isFollowing'],
        categories: (data['categories'] as List)
            .map((e) => Category.fromJson(e))
            .toList());
  }

  static Future<List<Novel>> getNovels({
    String? sort,
    int? gene,
    String? status,
  }) async {
    return catchError(() async {
      final res = await getApi().get('/novels',
          queryParameters: {'sort': sort, 'gene': gene, 'status': status});

      final data = (res.data as List)
          .map((e) => Novel.fromJson(e as Map<String, dynamic>))
          .toList();

      return data;
    });
  }

  static Future<bool> follow({required int id}) {
    return catchError(() async {
      final res = await getApi().post('/novels/$id/follow');

      return res.data['result'] as bool;
    });
  }
}
