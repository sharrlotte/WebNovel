import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/chapter.dart';
import 'package:frontend/models/novel.dart';

class AddChapterPage extends StatefulWidget {
  final Novel novel;
  const AddChapterPage({super.key, required this.novel});

  @override
  State<AddChapterPage> createState() => _AddChapterPageState();
}

class _AddChapterPageState extends State<AddChapterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NavScaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                          labelText: 'Tên chương',
                          labelStyle: TextStyle(fontSize: 16)),
                      controller: nameController,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                          labelText: 'Nội dung',
                          labelStyle: TextStyle(fontSize: 16)),
                      controller: contentController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        QueryClientBuilder(
                            builder: (context, queryClient) => ElevatedButton(
                                  child: const Row(
                                    children: [
                                      Icon(Icons.save),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text("Đăng")
                                    ],
                                  ),
                                  onPressed: () async {
                                    if (nameController.text.isEmpty ||
                                        contentController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Vui lòng nhập nội dung'),
                                        ),
                                      );
                                      return;
                                    }

                                    try {
                                      await Chapter.addChapter(
                                          novelId: widget.novel.id,
                                          name: nameController.text,
                                          content: contentController.text);

                                      if (context.mounted) {
                                        nameController.clear();
                                        contentController.clear();

                                        queryClient.invalidateQueries(
                                            [widget.novel.id, 'chapters'],
                                            exact: false);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Đăng thành công'),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Đã xảy ra lỗi $e',
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                    }
                                  },
                                ))
                      ],
                    )
                  ],
                ))));
  }
}
