import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/session_cubit.dart';
import 'package:frontend/models/novel.dart';
import '../pages/novel_detail_page.dart';

class NovelCard extends StatefulWidget {
  final Novel novel;

  const NovelCard({
    required super.key,
    required this.novel,
  });

  @override
  State<NovelCard> createState() => _NovelCardState();
}

class _NovelCardState extends State<NovelCard> {
  @override
  void initState() {
    super.initState();
  }

  follow(int novelId) async {
    final result = await Novel.follow(id: novelId);

    setState(() {
      widget.novel.isFollowing = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NovelDetailPage(novel: widget.novel),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh truyện
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image(
                      image: NetworkImage(widget.novel.cover),
                      errorBuilder: (context, error, stackTrace) =>
                          Text(error.toString()),
                    ),
                  ),
                ),
                // Phần thông tin
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề truyện
                      Text(
                        widget.novel.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Số chương
                      Text(
                        widget.novel.author,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Icon trái tim
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: BlocBuilder<SessionCubit, SessionState>(
                    builder: (context, session) {
                      return GestureDetector(
                        child: Icon(
                          widget.novel.isFollowing
                              ? Icons.bookmark
                              : Icons.bookmark_add,
                          color: widget.novel.isFollowing
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                        onTap: () {
                          if (session is! Authenticated) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Đăng nhập để theo dõi truyện",
                                style: TextStyle(color: Colors.red),
                              ),
                            ));
                          } else {
                            setState(() {
                              widget.novel.isFollowing =
                                  !widget.novel.isFollowing;
                            });
                            follow(widget.novel.id);
                          }
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
