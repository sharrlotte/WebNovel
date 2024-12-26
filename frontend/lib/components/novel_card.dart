import 'package:flutter/material.dart';
import 'package:frontend/models/novel_model.dart';
import 'novel_detail_page.dart';

class NovelCard extends StatefulWidget {
  final Novel novel;
  final bool isFollowed;
  final Function(bool)? onFollowChanged;

  const NovelCard({
    required super.key,
    required this.novel,
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
                    child: Image(image: NetworkImage(widget.novel.cover)),
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
                child: IconButton(
                  iconSize: 20,
                  padding: const EdgeInsets.all(0),
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
