import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/pages/novel_detail_page.dart';
import 'dart:async';

import 'package:frontend/models/novel.dart';

class MainSlider extends StatefulWidget {
  const MainSlider({super.key});

  @override
  State<MainSlider> createState() => _MainSliderState();
}

class _MainSliderState extends State<MainSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  late List<Novel> _novels = [];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_novels.isEmpty) {
        return;
      }

      if (_currentPage < _novels.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QueryClientBuilder(
        builder: (context, queryClient) => QueryBuilder<List<Novel>, Error>(
                const ['novels'], () => Novel.getNovels(),
                refetchInterval: const Duration(seconds: 100),
                builder: (context, novels) {
              _novels = novels.data ?? [];
              var data = novels.data;

              if (novels.isError) {
                return Text(novels.error.toString());
              }

              if (data == null || novels.isLoading || data.isEmpty) {
                return const SizedBox(height: 400);
              }

              return SizedBox(
                  height: 400,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // PageView để vuốt
                          PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index % data.length;
                              });
                            },
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NovelDetailPage(novel: data[index]),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      // Ảnh nền
                                      SizedBox(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Image.network(
                                          data[index].cover,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      // Gradient overlay
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          ),
                          // Text content
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[_currentPage].name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${data[_currentPage].description.substring(0, min(25, data[_currentPage].description.length))}...",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Dots indicator
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                data.length,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == _currentPage
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )));
            }));
  }
}
