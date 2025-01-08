import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/api.dart';
import 'package:frontend/models/category.dart';
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

  List<Category> selectedCategories = [];
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
                    const Text("Thể loại"),
                    const SizedBox(
                      height: 8,
                    ),
                    Wrap(
                      children: selectedCategories
                          .map((item) => TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedCategories = selectedCategories
                                      .where((i) => i.id != item.id)
                                      .toList();
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(item.name),
                                  const Icon(Icons.close)
                                ],
                              )))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    QueryBuilder(
                        const ['categories'], //
                        Category.getCategories, //
                        builder: (context, query) {
                      final categories = query.data ?? [];

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Category>(
                            isExpanded: true,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            hint: const Text('Thêm thể loại'),
                            items: categories
                                .where((item) => !selectedCategories
                                    .map((i) => i.id)
                                    .contains(item.id))
                                .map((genre) => DropdownMenuItem<Category>(
                                      value: genre,
                                      child: Text(genre.name),
                                    ))
                                .toList(),
                            onChanged: (Category? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  selectedCategories = [
                                    ...selectedCategories,
                                    newValue
                                  ];
                                }
                              });
                            },
                          ),
                        ),
                      );
                    }),
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
                                onPressed: () async {
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

                                  if (selectedCategories.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Vui lòng chọn một thể loại",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ));
                                    return;
                                  }

                                  if (cover.isEmpty) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Vui lòng chọn ảnh bìa",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ));
                                      return;
                                    }
                                  }

                                  try {
                                    await Novel.createNovel(
                                        name: nameController.text,
                                        description: descriptionController.text,
                                        author: authorController.text,
                                        cover: cover,
                                        categoryIds: selectedCategories
                                            .map((i) => i.id)
                                            .toList());

                                    queryClient.invalidateQueries(['novels'],
                                        exact: false);

                                    setState(() {
                                      cover = "";
                                      selectedCategories = [];
                                      nameController.clear();
                                      authorController.clear();
                                      descriptionController.clear();
                                    });

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Đăng truyện thành công",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ));
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "Lỗi đăng truyện: $e",
                                          style: const TextStyle(
                                              color: Colors.red),
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
