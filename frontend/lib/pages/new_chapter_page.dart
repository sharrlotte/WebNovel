import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/bloc/session_cubit.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/novel.dart';
import 'package:frontend/pages/novel_detail_page.dart';

class NewChapterPage extends StatefulWidget {
  const NewChapterPage({super.key});

  @override
  State<NewChapterPage> createState() => _NewChapterState();
}

class _NewChapterState extends State<NewChapterPage> {
  @override
  Widget build(BuildContext context) {
    return NavScaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: QueryBuilder(const ['new-chapter'], Novel.getNewNovel,
                builder: (context, query) {
              if (query.isLoading) {
                return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator()),
                );
              }

              if (query.isError) {
                return Column(
                  children: [Text("Đã xảy ra lỗi: ${query.error}")],
                );
              }

              final data = query.data;

              if (data == null || data.isEmpty) {
                return const Center(
                  child: Text(
                      'Không có chương mới của truyện mà bạn đang theo dõi'),
                );
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return NewNovelCard(
                    key: Key(data[index].id.toString()),
                    novel: data[index],
                  );
                },
              );
            })));
  }
}

class NewNovelCard extends StatefulWidget {
  final NewNovel novel;

  const NewNovelCard({
    required super.key,
    required this.novel,
  });

  @override
  State<NewNovelCard> createState() => _NewNovelCardState();
}

class _NewNovelCardState extends State<NewNovelCard> {
  @override
  void initState() {
    super.initState();
    widget.novel.isFollowing = true;
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
            builder: (context) =>
                NovelDetailPage(novel: widget.novel.toNovel()),
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
            Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.novel.cover),
                      ),
                      Text(
                        widget.novel.name,
                        textAlign: TextAlign.end,
                      ),
                    ])),
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
