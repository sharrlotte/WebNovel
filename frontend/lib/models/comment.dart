import 'package:frontend/models/session.dart';

class Comment {
  final int id;
  final int? chapterId;
  final String content;

  final DateTime createdAt;

  final User user;

  Comment({
    required this.chapterId,
    required this.content,
    required this.createdAt,
    required this.user,
    required this.id,
  });

  static Comment fromJson(Map<String, dynamic> data) {
    return Comment(
        id: data['id'],
        content: data['content'],
        createdAt: DateTime.parse(data['createdAt']),
        user: User.fromJson(data['user']),
        chapterId: data['chapterId']);
  }
}
