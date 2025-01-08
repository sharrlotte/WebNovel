import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/models/chapter.dart';
import 'package:frontend/utils.dart';

class ChapterCommentList extends StatelessWidget {
  final Chapter chapter;
  final TextEditingController contentController = TextEditingController();

  ChapterCommentList({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return QueryClientBuilder(
        builder: (context, queryClient) => Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: TextField(
                      controller: contentController,
                      decoration:
                          const InputDecoration(labelText: "Bình luận của bạn"),
                    )),
                    IconButton(
                        onPressed: () async {
                          try {
                            if (contentController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Vui lòng nhập bình luận")));
                              return;
                            }
                            await Chapter.createComments(
                                id: chapter.novelId,
                                chapterId: chapter.id,
                                content: contentController.text);
                            contentController.clear();
                            queryClient
                                .invalidateQueries(['comments'], exact: false);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Lỗi $e")));
                            }
                          }
                        },
                        style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                        icon: const Icon(Icons.send))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("Bình luận: ${chapter.comment}",
                    textAlign: TextAlign.start),
                const SizedBox(
                  height: 10,
                ),
                QueryBuilder(
                    ['comments', chapter.novelId, 'chapter', chapter.id],
                    () => Chapter.getComments(
                        id: chapter.novelId,
                        chapterId: chapter.id), builder: (context, query) {
                  if (query.isError) {
                    return Text('Error: ${query.error}');
                  }

                  if (query.isLoading) {
                    return const Center(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator()),
                    );
                  }

                  final comments = query.data;

                  if (comments == null || comments.isEmpty) {
                    return const Text('Chưa có bình luận nào cả');
                  }

                  return Column(
                    children: comments
                        .map((comment) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage: NetworkImage(
                                    comment.user.avatar ?? defaultImageLink,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    Text(comment.user.name ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(comment.content),
                                  ],
                                )),
                                Text(formatDate(comment.createdAt),
                                    style: const TextStyle(color: Colors.grey)),
                              ],
                            ))
                        .toList(),
                  );
                })
              ],
            ));
  }
}
