import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/components/chapter_comment_list.dart';
import 'package:frontend/models/chapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';

class ChapterPage extends StatefulWidget {
  final Chapter chapter;

  const ChapterPage({super.key, required this.chapter});
  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  @override
  void initState() {
    super.initState();
    _saveReadingHistory();
    view();
  }

  void view() {
    try {
      Chapter.view(id: widget.chapter.novelId, chapterId: widget.chapter.id);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveReadingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<Chapter>? history =
        (prefs.getStringList('readingHistory') ?? []).map((e) {
      final json = jsonDecode(e);

      return Chapter.fromJson(json);
    }).toList();

    Chapter? chapter = history.cast<Chapter?>().firstWhere(
        (h) => h?.novelId == widget.chapter.novelId,
        orElse: () => null);

    if (chapter == null) {
      history.add(widget.chapter);
    } else {
      if (chapter.id < widget.chapter.id) {
        history.remove(chapter);
        history.add(widget.chapter);
      }
    }

    await prefs.setStringList(
        'readingHistory',
        history
            .map((e) => jsonEncode({
                  'novelId': e.novelId,
                  'id': e.id,
                  'name': e.name,
                  'createdAt': e.createdAt.toString(),
                  'content': e.content,
                  'comment': e.comment,
                }))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: const Color.fromARGB(255, 234, 228, 211),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Cập nhật: ${formatDate(widget.chapter.createdAt)}"),
                                  Text(
                                      "Độ dài: ${widget.chapter.content.length} từ"),
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
                            const Spacer(),
                            NextChapterButton(currentChapter: widget.chapter),
                            const Divider(),
                            ChapterCommentList(chapter: widget.chapter)
                          ],
                        )),
                  )));
        }));
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
          child: Padding(
              padding: EdgeInsets.all(10), child: CircularProgressIndicator()),
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
