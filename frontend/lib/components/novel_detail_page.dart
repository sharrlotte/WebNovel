import 'package:flutter/material.dart';

class NovelDetailPage extends StatefulWidget {
  final Map<String, dynamic> novel;

  const NovelDetailPage({super.key, required this.novel});

  @override
  State<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  late bool isFollowed;

  @override
  void initState() {
    super.initState();
    isFollowed = widget.novel['isFollowed'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      image: AssetImage(widget.novel['imagePath']),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                // Nút back
                SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            // Thông tin novel
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.novel['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Tác giả: ${widget.novel['author'] ?? 'Không xác định'}'),
                  const SizedBox(height: 16),
                  // Thể loại
                  Wrap(
                    spacing: 8,
                    children: [
                      'manga',
                      'slice of life',
                      'học đường',
                      'romance',
                    ].map((tag) => Chip(label: Text(tag))).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Mô tả
                  const Text(
                    'Mô tả:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.novel['description'] ?? 'Chưa có mô tả'),
                  const SizedBox(height: 24),
                  // Danh sách chapter
                  const Text(
                    'Danh sách Chapter:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10, // Số lượng chapter
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Chapter ${index + 1}'),
                        onTap: () {
                          // Xử lý khi bấm vào chapter
                        },
                      );
                    },
                  ),
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
        backgroundColor: isFollowed ? Colors.grey : Theme.of(context).primaryColor,
      ),
    );
  }
}
