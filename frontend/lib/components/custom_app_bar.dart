import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/session_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    void onMenuSelected(value) async {
      final cubit = context.read<SessionCubit>();

      switch (value) {
        case "/":
          Navigator.pushNamed(context, '/');
          break;

        case "login":
          Navigator.pushNamed(context, '/login');
          break;

        case "upload":
          Navigator.pushNamed(context, '/upload');
          break;

        case "logout":
          await cubit.signOut();
          break;
      }
    }

    return AppBar(
      elevation: 2,
      title: const Text(
        "SAKURA NOVEL",
        style: TextStyle(
            color: Color.fromARGB(255, 236, 192, 216),
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      actions: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                //TODO: Xử lý tìm kiếm
              },
            )),
        BlocBuilder<SessionCubit, SessionState>(builder: (context, session) {
          if (session is Authenticated) {
            final avatar = session.session.user.avatar;

            if (avatar != null) {
              return CircleAvatar(
                  backgroundImage: NetworkImage(avatar), radius: 12);
            } else {
              return const CircleAvatar();
            }
          }

          return Container();
        }),
        BlocBuilder<SessionCubit, SessionState>(builder: (context, session) {
          return PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.black),
            onSelected: onMenuSelected,
            itemBuilder: (BuildContext context) {
              final isLoggedIn = session is Authenticated;
              return [
                const PopupMenuItem(value: "/", child: Text("Trang chủ")),
                ...(isLoggedIn
                    ? [
                        const PopupMenuItem(
                            value: "logout", child: Text("Đăng Xuất")),
                        const PopupMenuItem(
                            value: "downloads",
                            child: Text("Truyện đã tải xuống")),
                        const PopupMenuItem(
                            value: "upload", child: Text("Truyện của tôi")),
                      ]
                    : [
                        const PopupMenuItem(
                            value: "login", child: Text("Đăng nhập")),
                      ]),
                const PopupMenuItem(value: "news", child: Text("Tin tức")),
                const PopupMenuItem(value: "fanpage", child: Text("Fanpage")),
                const PopupMenuItem(
                    value: "hidden_group", child: Text("Hội kín")),
              ];
            },
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
