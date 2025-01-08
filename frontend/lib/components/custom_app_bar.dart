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

        case "my-novel":
          Navigator.pushNamed(context, '/my-novel');
          break;

        case "upload":
          Navigator.pushNamed(context, '/upload');
          break;

        case "history":
          Navigator.pushNamed(context, '/history');
          break;

        case "favorites":
          Navigator.pushNamed(context, '/favorites');
          break;

        case "logout":
          await cubit.signOut();
          break;

        default:
          Navigator.pushNamed(context, '/');
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
                const PopupMenuItem(
                    value: "/",
                    child: Row(
                      children: [Icon(Icons.home), Text("Trang chủ")],
                    )),
                ...(isLoggedIn
                    ? [
                        const PopupMenuItem(
                            value: "logout",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text("Đăng xuất")
                              ],
                            )),
                        const PopupMenuItem(
                            value: "downloads",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.download,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text("Truyện đã tải xuống")
                              ],
                            )),
                        const PopupMenuItem(
                            value: "favorites",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text("Truyện đã theo dõi")
                              ],
                            )),
                        const PopupMenuItem(
                            value: "my-novel",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.upload,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text("Truyện của tôi")
                              ],
                            )),
                      ]
                    : [
                        const PopupMenuItem(
                            value: "login",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.login,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text("Đăng nhâp")
                              ],
                            )),
                      ]),
                const PopupMenuItem(
                    value: "history",
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          size: 22,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text("Truyện đang đọc")
                      ],
                    )),
                const PopupMenuItem(
                    value: "news",
                    child: Row(
                      children: [
                        Icon(
                          Icons.newspaper,
                          size: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text("Tin tức")
                      ],
                    )),
                const PopupMenuItem(
                    value: "fanpage",
                    child: Row(
                      children: [
                        Icon(
                          Icons.facebook,
                          size: 22,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text("Fan page")
                      ],
                    )),
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
