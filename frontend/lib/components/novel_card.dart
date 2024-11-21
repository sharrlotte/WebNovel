import 'package:flutter/material.dart';
import 'novel_detail_page.dart';

class NovelCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String chapter;
  final bool isFollowed;
  final Function(bool)? onFollowChanged;

  const NovelCard({
    required super.key,
    required this.imagePath,
    required this.title,
    required this.chapter,
    this.isFollowed = false,
    this.onFollowChanged,
  });

  @override
  State<NovelCard> createState() => _NovelCardState();
}

class _NovelCardState extends State<NovelCard> {
  late bool _isFollowed;

  @override
  void initState() {
    super.initState();
    _isFollowed = widget.isFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NovelDetailPage(
              novel: {
                'imagePath': widget.imagePath,
                'title': widget.title,
                'chapter': widget.chapter,
                'isFollowed': _isFollowed,
              },
            ),
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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.asset(
                      widget.imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
                        widget.title,
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
                        widget.chapter,
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
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 20,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _isFollowed ? Icons.favorite : Icons.favorite_border,
                    color: _isFollowed ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFollowed = !_isFollowed;
                    });
                    widget.onFollowChanged?.call(_isFollowed);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
