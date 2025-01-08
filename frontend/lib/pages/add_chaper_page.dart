import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
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
    return const NavScaffold(
        body: Column(
      children: [

      ],
    ));
  }
}
