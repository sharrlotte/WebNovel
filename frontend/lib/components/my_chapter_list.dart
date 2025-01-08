import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/models/chapter.dart';
import 'package:frontend/pages/add_chaper_page.dart';
import 'package:frontend/pages/chapter_page.dart';

import '../models/novel.dart';

class MyNovelChapterList extends StatefulWidget {
  final Novel novel;

  const MyNovelChapterList({super.key, required this.novel});

  @override
  State<MyNovelChapterList> createState() => _MyNovelChapterListState();
}

class _MyNovelChapterListState extends State<MyNovelChapterList> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Danh sách Chapter:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
                style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 10))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddChapterPage(
                        novel: widget.novel,
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                    ),
                    Text(
                      "Thêm chương",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                )),
          ],
        ),
        QueryClientBuilder(
            builder: (context, queryClient) =>
                QueryBuilder<List<Chapter>, Error>([
                  widget.novel.id,
                  'chapters',
                  page
                ], () => Chapter.getChapters(novelId: widget.novel.id, page: 1),
                    refetchInterval: const Duration(seconds: 100),
                    builder: (context, data) {
                  var chapters = data.data;

                  if (data.isError) {
                    return Text(data.error.toString());
                  }

                  if (data.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (chapters == null || chapters.isEmpty) {
                    return const Text("Không có chương");
                  }

                  return Column(
                      children: chapters
                          .map((chapter) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChapterPage(chapter: chapter),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  chapter.name,
                                ),
                              )))
                          .toList());
                }))
      ],
    );
  }
}
