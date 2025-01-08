import 'package:flutter/material.dart';
import 'package:frontend/components/chapter_list.dart';
import 'package:frontend/components/custom_app_bar.dart';
import 'package:frontend/models/api.dart';
import 'package:frontend/models/novel.dart';
import 'package:image_picker/image_picker.dart';

const List<Map<String, String>> status = [
  {'id': 'COMPLETED', 'name': 'Hoàn thành'},
  {'id': 'ON_GOING', 'name': 'Đang tiến hành'},
  {'id': 'PAUSED', 'name': 'Đã ngưng'},
];

class MyNovelDetailPage extends StatefulWidget {
  final Novel novel;

  const MyNovelDetailPage({super.key, required this.novel});

  @override
  State<MyNovelDetailPage> createState() => _MyNovelDetailPageState();
}

class _MyNovelDetailPageState extends State<MyNovelDetailPage> {
  late bool isFollowed;
  bool isEditing = false;

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
          child: Padding(
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
      )),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            setState(() {
              isEditing = !isEditing;
            });
          },
          child: const Icon(Icons.edit)),
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
          'Danh sách chapter:',
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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  late String selectedStatus;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.novel.name;
    authorController.text = widget.novel.author;
    descriptionController.text = widget.novel.description;
    selectedStatus = widget.novel.status;
  }

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

              try {
                var url = await Api.uploadImage(file);

                Novel.updateNovelCover(id: widget.novel.id, url: url);

                setState(() {
                  widget.novel.cover = url;
                });
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Lỗi tải ảnh: $e",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ));
                }
              }
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
        TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Tên',
            )),
        const SizedBox(
          height: 10,
        ),
        TextField(
            controller: authorController,
            decoration: const InputDecoration(
              labelText: 'Tác giả',
            )),
        const SizedBox(
          height: 10,
        ),
        const Row(
          children: [
            Text(
              "Trạng thái",
              textAlign: TextAlign.start,
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: status.any((s) => s['id'] == selectedStatus)
                  ? selectedStatus
                  : status.first['id'],
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              hint: const Text('Tình trạng'),
              items: status
                  .map((sort) => DropdownMenuItem<String>(
                        value: sort['id'],
                        child: Text(sort['name']!),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                  ;
                }
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Mô tả',
            )),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  try {
                    Novel.updateNovel(
                        id: widget.novel.id,
                        name: titleController.text,
                        description: descriptionController.text,
                        author: authorController.text,
                        status: selectedStatus);

                    setState(() {
                      widget.novel.author = authorController.text;
                      widget.novel.description = descriptionController.text;
                      widget.novel.name = titleController.text;
                      widget.novel.status = selectedStatus;
                    });

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Cập nhật thành công")));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "L��i cập nhật: $e",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ));
                    }
                  }
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.save,
                      size: 20,
                    ),
                    Text("Lưu"),
                  ],
                ))
          ],
        )
      ],
    );
  }
}
