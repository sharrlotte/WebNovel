import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onMenuSelected;

  const CustomAppBar({super.key, required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      title: const Text(
        "SAKURA NOVEL",
        style: TextStyle(color: Color.fromARGB(255, 236, 192, 216)),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Xử lý tìm kiếm
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: onMenuSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(value: "/", child: Text("Trang chủ")),
                const PopupMenuItem(value: "login", child: Text("Đăng nhập")),
                const PopupMenuItem(
                    value: "downloads", child: Text("Truyện đã tải xuống")),
                const PopupMenuItem(
                    value: "upload", child: Text("Đăng truyện")),
                const PopupMenuItem(value: "news", child: Text("Tin tức")),
                const PopupMenuItem(value: "fanpage", child: Text("Fanpage")),
                const PopupMenuItem(
                    value: "hidden_group", child: Text("Hội kín")),
              ];
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
