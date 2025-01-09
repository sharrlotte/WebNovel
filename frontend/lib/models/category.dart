import 'package:frontend/utils.dart';

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

  static Future<List<Category>> getCategories() {
    return catchError(() async {
      final res = await getApi().get("/categories");

      return (res.data as List<dynamic>)
          .map((item) => Category.fromJson(item))
          .toList();
    });
  }

  static Future<Category> createCategory(String name) {
    return catchError(() async {
      final res = await getApi().post('/categories', data: {'name': name});

      return Category.fromJson(res.data);
    });
  }

  static Future<dynamic> deleteCategory(int id) {
    return catchError(() async {
      await getApi().delete('/categories/$id');
    });
  }
}
