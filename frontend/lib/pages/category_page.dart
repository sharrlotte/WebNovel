import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QueryBuilder(
                    const ['categories'], //
                    Category.getCategories, //
                    builder: (context, query) {
                  if (query.isLoading) {
                    return const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(child: CircularProgressIndicator()));
                  }

                  if (query.isError) {
                    return Text('Error: ${query.error}');
                  }
                  final categories = query.data;

                  if (categories == null || categories.isEmpty) {
                    return const Text('Không có thể loại');
                  }

                  return Wrap(
                    spacing: 20,
                    children: categories
                        .map((category) => Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  category.name,
                                  textAlign: TextAlign.start,
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Xác nhận xóa'),
                                          content: Text(
                                              'Bạn có chắc muốn xóa loại ${category.name}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                              child: const Text('Hủy'),
                                            ),
                                            QueryClientBuilder(
                                              builder: (context, queryClient) =>
                                                  TextButton(
                                                onPressed: () async {
                                                  // Delete category
                                                  try {
                                                    await Category
                                                        .deleteCategory(
                                                            category.id);
                                                    if (context.mounted) {
                                                      queryClient
                                                          .invalidateQueries(
                                                              ['categories'],
                                                              exact: false);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                          'Xóa thành công',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ));
                                                      Navigator.pop(context);
                                                    }
                                                  } catch (e) {
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                          'Xóa thất bại $e',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ));
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                  'Xóa',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.close))
                              ],
                            )))
                        .toList(),
                  );
                })
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => const Dialog(
                    child: AddCategoryForm(),
                  ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({super.key});

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return QueryClientBuilder(builder: (context, queryClient) {
      return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên loại',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("Hủy"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'Tên loại không được để trống',
                            style: TextStyle(color: Colors.red),
                          ),
                        ));
                        return;
                      }
                      await Category.createCategory(nameController.text);
                      if (context.mounted) {
                        queryClient
                            .invalidateQueries(['categories'], exact: false);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'Thêm thành công',
                            style: TextStyle(color: Colors.green),
                          ),
                        ));
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Xóa thất bại $e',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ));
                      }
                    }
                  },
                  child: const Text("Thêm"),
                )
              ],
            )
          ]));
    });
  }
}
