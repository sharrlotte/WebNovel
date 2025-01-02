import 'package:flutter/material.dart';
import 'package:frontend/components/chapter_list.dart';
import 'package:frontend/components/custom_app_bar.dart';
import 'package:frontend/models/api.dart';
import 'package:frontend/models/novel.dart';
import 'package:image_picker/image_picker.dart';

import '../models/query.dart';

class UploadNovelDetailPage extends StatefulWidget {
  final Novel novel;

  const UploadNovelDetailPage({super.key, required this.novel});

  @override
  State<UploadNovelDetailPage> createState() => _UploadNovelDetailPageState();
}

class _UploadNovelDetailPageState extends State<UploadNovelDetailPage> {
  late bool isFollowed;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    isFollowed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isEditing
                    ? EditNovel(novel: widget.novel)
                    : NovelInfo(novel: widget.novel),
                NovelChapterList(novel: widget.novel),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
                onPressed: () {
                  print("Edit");
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                icon: const Icon(Icons.edit)),
          ),
        ],
      )),
    );
  }
}

class NovelInfo extends StatelessWidget {
  final Novel novel;

  const NovelInfo({super.key, required this.novel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(novel.cover), fit: BoxFit.contain),
          ),
        ),
        Text(
          novel.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('Tác giả: ${novel.author}'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: novel.categories
              .map((tag) => Chip(label: Text(tag.name)))
              .toList(),
        ),
        const SizedBox(height: 16),
        const Text(
          'Trạng thái:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(status.firstWhere((item) => item['id'] == novel.status)['name'] ??
            "Lỗi"),
        const SizedBox(height: 16),
        const Text(
          'Mô tả:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(novel.description),
        const SizedBox(height: 16),
        const Text(
          'Danh sách Chapter:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class EditNovel extends StatefulWidget {
  final Novel novel;

  const EditNovel({super.key, required this.novel});

  @override
  State<EditNovel> createState() => _EditNovelState();
}

class _EditNovelState extends State<EditNovel> {
  final TextEditingController controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              final XFile? file =
                  await _picker.pickImage(source: ImageSource.gallery);

              if (file == null) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Vui lòng chọn một ảnh",
                      style: TextStyle(color: Colors.red),
                    ),
                  ));
                }
                return;
              }

              var url = await Api.uploadImage(file);

              print(url);

              setState(() {
                widget.novel.cover = url;
              });
            },
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.novel.cover),
                    fit: BoxFit.contain),
              ),
            )),
      ],
    );
  }
}
