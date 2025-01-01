import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/utils.dart';

class Chapter {
  final int id;
  final String name;
  final String content;
  final DateTime createdAt;
  final int novelId;
  final int comment;

  Chapter({
    required this.comment,
    required this.id,
    required this.name,
    required this.content,
    required this.createdAt,
    required this.novelId,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
        id: json['id'],
        name: json['name'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
        novelId: json['novelId'],
        comment: ((json['comment'] ?? 0) as int));
  }

  static Future<List<Chapter>> getChapters({
    required int novelId,
    required int page,
  }) async {
    return catchError(() async {
      final res = await Dio().get(
          '${dotenv.env['API_URL']}/novels/$novelId/chapters',
          queryParameters: {
            'page': page,
          });

      final data = (res.data as List)
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList();

      return data;
    });
  }

  static Future<Chapter?> getNextChapter(
      {required int novelId, required int chapterId}) {
    return catchError(() async {
      final res =
          await getApi().get('/novels/$novelId/chapters/$chapterId/next');

      if (res.data == '') {
        return null;
      }

      return Chapter.fromJson(res.data);
    });
  }
}
