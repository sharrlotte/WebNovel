import 'package:flutter/material.dart';
import 'package:frontend/components/chapter_list.dart';
import 'package:frontend/components/custom_app_bar.dart';
import 'package:frontend/models/novel.dart';

import '../models/query.dart';

class NovelDetailPage extends StatefulWidget {
  final Novel novel;

  const NovelDetailPage({super.key, required this.novel});

  @override
  State<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  late bool isFollowed;

  @override
  void initState() {
    super.initState();

    isFollowed = widget.novel.isFollowing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với ảnh và thông tin cơ bản
            Stack(
              children: [
                // Ảnh nền mờ
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.novel.cover),
                        fit: BoxFit.contain),
                  ),
                ),
                // Nút back
              ],
            ),
            // Thông tin novel
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.novel.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Tác giả: ${widget.novel.author}'),
                  const SizedBox(height: 16),
                  // Thể loại
                  Wrap(
                    spacing: 8,
                    children: widget.novel.categories
                        .map((tag) => Chip(label: Text(tag.name)))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  // Mô tả
                  const Text(
                    'Trạng thái:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(status.firstWhere((item) =>
                          item['id'] == widget.novel.status)['name'] ??
                      "Lỗi"),
                  const SizedBox(height: 16),
                  // Mô  /
                  const Text(
                    'Mô tả:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.novel.description),
                  const SizedBox(height: 16),
                  // Danh sách chapter
                  const Text(
                    'Danh sách Chapter:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  NovelChapterList(novel: widget.novel),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            isFollowed = !isFollowed;
          });
        },
        label: Text(isFollowed ? 'Đã theo dõi' : 'Theo dõi'),
        icon: Icon(isFollowed ? Icons.bookmark : Icons.bookmark_add),
        backgroundColor:
            !isFollowed ? Colors.white : Theme.of(context).primaryColor,
        foregroundColor:
            isFollowed ? Colors.white : Theme.of(context).primaryColor,
      ),
    );
  }
}
