  import 'package:flutter/material.dart';
  import 'package:frontend/components/ranking_novel.dart';
  import '../components/novel_card.dart';
  import '../components/custom_app_bar.dart';
  import '../components/slider.dart';
  import 'package:logger/logger.dart';


  class HomePage extends StatelessWidget {
    HomePage({super.key});

    final List<Map<String, dynamic>> _novels = [
      {
        'imagePath': 'assets/images/gi1.jpg',
        'title': 'Tiểu thuyết 1',
        'chapter': 'Chương 1',
        'isFollowed': false,
      },
      {
        'imagePath': 'assets/images/gi1.jpg',
        'title': 'Tiểu thuyết 1',
        'chapter': 'Chương 1',
        'isFollowed': false,
      },
      {
        'imagePath': 'assets/images/gi1.jpg',
        'title': 'Tiểu thuyết 1',
        'chapter': 'Chương 1',
        'isFollowed': false,
      },
      {
        'imagePath': 'assets/images/gi1.jpg',
        'title': 'Tiểu thuyết 1',
        'chapter': 'Chương 1',
        'isFollowed': false,
      },
      {
        'imagePath': 'assets/images/gi1.jpg',
        'title': 'Tiểu thuyết 1',
        'chapter': 'Chương 1',
        'isFollowed': false,
      },
      {
        'imagePath': 'assets/images/gi1.jpg',
        'title': 'Tiểu thuyết 1',
        'chapter': 'Chương 1',
        'isFollowed': false,
      },
      // Thêm các tiểu thuyết khác tương tự
    ];

    final logger = Logger();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: CustomAppBar(
          onMenuSelected: (value) {
            switch (value) {
              case "login":
                Navigator.pushNamed(context, '/login');
                break;
              case "register":
                Navigator.pushNamed(context, '/register');
                break;
              case "downloads":
                Navigator.pushNamed(context, '/downloads');
                break;
              // ... xử lý các case khác tương tự
            }
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MainSlider(),
              RankingNovel(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Truyện Mới Cập Nhật',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 250, // Chiều cao cố định
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _novels.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 140, // Chiều rộng của mỗi card
                      margin: const EdgeInsets.only(right: 12),
                      child: NovelCard(
                        key: Key('novel_$index'),
                        imagePath: _novels[index]['imagePath'] ?? '',
                        title: _novels[index]['title'] ?? '',
                        chapter: _novels[index]['chapter'] ?? '',
                        isFollowed: _novels[index]['isFollowed'] == 'true',
                        onFollowChanged: (isFollowed) {
                          logger.i('Novel ${_novels[index]['title']} is ${isFollowed ? 'followed' : 'unfollowed'}');
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

