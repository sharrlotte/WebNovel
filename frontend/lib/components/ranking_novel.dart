import 'package:flutter/material.dart';
import 'novel_card.dart';

class RankingNovel extends StatelessWidget {
  RankingNovel({super.key});

  final List<Map<String, dynamic>> _featuredNovels = [
    {
      'imagePath': 'assets/images/gi1.jpg',
      'title': 'Truyện Nổi Bật 1',
      'chapter': 'Chương 1',
      'readers': 10000,
      'rank': 1,
    },
    {
      'imagePath': 'assets/images/gi1.jpg',
      'title': 'Truyện Nổi Bật 2',
      'chapter': 'Chương 1',
      'readers': 8000,
      'rank': 2,
    },
    {
      'imagePath': 'assets/images/gi1.jpg',
      'title': 'Truyện Nổi Bật 2',
      'chapter': 'Chương 1',
      'readers': 5600,
      'rank': 3,
    },
    {
      'imagePath': 'assets/images/gi1.jpg',
      'title': 'Truyện Nổi Bật 2',
      'chapter': 'Chương 1',
      'readers': 4560,
      'rank': 4,
    },
    // Thêm các truyện khác...
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Truyện Nổi Bật',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _featuredNovels.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      NovelCard(
                        key: Key('featured_$index'),
                        imagePath: _featuredNovels[index]['imagePath'],
                        title: _featuredNovels[index]['title'],
                        chapter: _featuredNovels[index]['chapter'],
                      ),
                      // Badge xếp hạng
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '#${_featuredNovels[index]['rank']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Số lượng người đọc
                      Positioned(
                        bottom: 40,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_featuredNovels[index]['readers']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
