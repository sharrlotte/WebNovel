import 'package:frontend/models/category.dart';
import 'package:frontend/utils.dart';

class Novel {
  final int id;
  String name;
  String cover;
  String description;
  String author;
  String status;
  bool isFollowing;
  final String createdAt;
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
        isFollowing: data['isFollowing'] ?? false,
        categories: (data['categories'] ?? [])
            .map((e) => Category.fromJson(e))
            .cast<Category>()
            .toList());
  }

  static Future<Novel> getNovelById(int id) async {
    return catchError(() async {
      final res = await getApi().get('/novels/$id');
      return Novel.fromJson(res.data);
    });
  }

  static Future<List<Novel>> getNovels({
    String? sort,
    int? gene,
    String? status,
    int? page = 1,
  }) async {
    return catchError(() async {
      final res = await getApi().get('/novels', queryParameters: {
        'sort': sort,
        'gene': gene,
        'status': status,
        'page': page
      });

      final data = (res.data as List)
          .map((e) => Novel.fromJson(e as Map<String, dynamic>))
          .toList();

      return data;
    });
  }

  static Future<List<Novel>> getFavoritesNovels({
    int? page = 1,
  }) async {
    return catchError(() async {
      final res = await getApi().get('/users/@me/favorites', queryParameters: {
        'page': page,
      });

      final data = (res.data as List)
          .map((e) => Novel.fromJson(e as Map<String, dynamic>))
          .toList();

      return data;
    });
  }

  static Future<List<Novel>> getMyNovels({
    String? sort,
    int? gene,
    String? status,
    int? page = 1,
  }) async {
    return catchError(() async {
      final res = await getApi().get('/users/@me/novels', queryParameters: {
        'sort': sort,
        'gene': gene,
        'status': status,
        'page': page
      });

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

  static Future<dynamic> updateNovelCover(
      {required int id, required String url}) {
    return catchError(() async {
      final res = await getApi().patch('/novels/$id', data: {'cover': url});

      return res;
    });
  }

  static Future<dynamic> updateNovel(
      {required int id,
      required String name,
      required String description,
      required String status,
      required String author}) {
    return catchError(() async {
      final res = await getApi().patch('/novels/$id', data: {
        'name': name,
        'description': description,
        'status': status,
        'author': author
      });

      return res;
    });
  }

  static Future<Novel> createNovel(
      {required String name,
      required String description,
      required String author}) {
    return catchError(() async {
      final res = await getApi().post('/novels',
          data: {'name': name, 'description': description, 'author': author});

      return Novel.fromJson(res.data);
    });
  }
}
