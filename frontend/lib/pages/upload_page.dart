import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/api.dart';
import 'package:frontend/models/novel.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String cover = "";

  @override
  Widget build(BuildContext context) {
    return NavScaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                        onPressed: () async {
                          final XFile? file = await _picker.pickImage(
                              source: ImageSource.gallery);

                          if (file == null) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
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

                            setState(() {
                              cover = url;
                            });
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "Lỗi tải ảnh: $e",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ));
                            }
                          }
                        },
                        child: cover.isEmpty
                            ? const Row(
                                children: [
                                  Icon(Icons.image),
                                  Text("Đăng ảnh bìa")
                                ],
                              )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(cover),
                                      fit: BoxFit.contain),
                                ),
                              )),
                    TextField(
                        controller: nameController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        QueryClientBuilder(
                            builder: (context, queryClient) => ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.isEmpty ||
                                      authorController.text.isEmpty ||
                                      descriptionController.text.isEmpty) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Vui lòng nhập đủ thông tin",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ));
                                      return;
                                    }
                                  }

                                  try {
                                    Novel.createNovel(
                                        name: nameController.text,
                                        description: descriptionController.text,
                                        author: authorController.text);
                                        
                                    queryClient.invalidateQueries(['novels'],
                                        exact: false);

                                    setState(() {
                                      cover = "";
                                      nameController.clear();
                                      authorController.clear();
                                      descriptionController.clear();
                                    });

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Đăng bài thành công",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ));
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "Lỗi đăng bài: $e",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ));
                                    }
                                  }
                                },
                                child: const Row(
                                    children: [Icon(Icons.save), Text("Lưu")])))
                      ],
                    )
                  ],
                ))));
  }
}
