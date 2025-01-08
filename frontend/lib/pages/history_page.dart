import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/models/chapter.dart';
import 'package:frontend/models/novel.dart';
import 'package:frontend/pages/chapter_page.dart';
import 'package:frontend/pages/novel_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var _history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<Chapter>? history =
        (prefs.getStringList('readingHistory') ?? []).map((e) {
      final json = jsonDecode(e);

      return Chapter.fromJson(json);
    }).toList();

    setState(() {
      _history = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text("Tên truyện"),
                  Spacer(),
                  Text("Đã đọc đến"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ..._history
                  .map((chapter) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ChapterNovelDetailCard(chapter: chapter),
                              const Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChapterPage(chapter: chapter),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        chapter.name,
                                      ),
                                      const Text(
                                        "Đọc tiếp",
                                        style: TextStyle(
                                            color: Colors.cyan, fontSize: 12),
                                      )
                                    ],
                                  ))
                            ]),
                      ))
                  .toList()
            ]));
  }
}

class ChapterNovelDetailCard extends StatelessWidget {
  final Chapter chapter;
  const ChapterNovelDetailCard({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return QueryClientBuilder(
        builder: (context, queryClient) => QueryBuilder<Novel, Error>(
                ['novels', chapter.novelId],
                () => Novel.getNovelById(chapter.novelId),
                refetchInterval: const Duration(seconds: 100),
                builder: (context, data) {
              var novel = data.data;

              if (data.isError) {
                return Text(data.error.toString());
              }

              if (data.isLoading) {
                return const SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                        child: SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator())));
              }

              if (novel == null) {
                return const Text("Không có novel");
              }

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NovelDetailPage(novel: novel),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image(
                        width: 50,
                        image: NetworkImage(novel.cover),
                      ),
                      Text(
                        novel.name,
                        textAlign: TextAlign.end,
                      )
                    ],
                  ));
            }));
  }
}
