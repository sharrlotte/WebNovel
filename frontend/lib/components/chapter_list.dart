import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/models/chapter.dart';
import 'package:frontend/pages/chapter_page.dart';

import '../models/novel.dart';

class NovelChapterList extends StatefulWidget {
  final Novel novel;

  const NovelChapterList({super.key, required this.novel});

  @override
  State<NovelChapterList> createState() => _NovelChapterListState();
}

class _NovelChapterListState extends State<NovelChapterList> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return QueryClientBuilder(
        builder: (context, queryClient) => QueryBuilder<List<Chapter>, Error>(
                [widget.novel.id, 'chapters', page],
                () => Chapter.getChapters(novelId: widget.novel.id, page: 0),
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
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              chapter.name,
                            ),
                          )))
                      .toList());
            }));
  }
}
