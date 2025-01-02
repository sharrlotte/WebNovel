import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/models/chapter.dart';

import '../utils.dart';

class ChapterPage extends StatefulWidget {
  final Chapter chapter;

  const ChapterPage({super.key, required this.chapter});
  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: const Color.fromARGB(255, 234, 228, 211),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    widget.chapter.name,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Cập nhật: ${formatDate(widget.chapter.createdAt)}"),
                        Text("Độ dài: ${widget.chapter.content.length} từ"),
                        Text("Bình luận: ${widget.chapter.comment}")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.chapter.content,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  NextChapterButton(currentChapter: widget.chapter)
                ],
              )),
        ));
  }
}

class NextChapterButton extends StatelessWidget {
  final Chapter currentChapter;

  const NextChapterButton({super.key, required this.currentChapter});

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
        ['chapters', currentChapter.id, 'next'],
        () => Chapter.getNextChapter(
            novelId: currentChapter.novelId,
            chapterId: currentChapter.id), builder: (context, query) {
      if (query.isError) {
        return Center(
          child: Text(query.error.toString()),
        );
      }

      if (query.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      var data = query.data;

      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: data == null
                  ? null
                  : () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChapterPage(chapter: data),
                          ),
                        )
                      },
              child: const Text("Chương kế"))
        ],
      );
    });
  }
}
