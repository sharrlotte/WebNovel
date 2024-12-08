import 'package:flutter/material.dart';

class NovelFilters extends StatelessWidget {
  final String selectedSortTag;
  final String selectedGenre;
  final Function(String) onSortTagChanged;
  final Function(String) onGenreChanged;

  const NovelFilters({
    super.key,
    required this.selectedSortTag,
    required this.selectedGenre,
    required this.onSortTagChanged,
    required this.onGenreChanged,
  });


  // Định nghĩa các thể loại
  static const List<Map<String, String>> _genres = [
    {'id': 'all', 'name': 'Tất cả'},
    {'id': 'comedy', 'name': 'Hài hước'},
    {'id': 'romance', 'name': 'Tình cảm'},
    {'id': 'action', 'name': 'Hành động'},
    // Thêm các thể loại khác
  ];

  // Cập nhật lại danh sách sắp xếp
  static const List<Map<String, String>> _sortOptions = [
    {'id': 'latest_update', 'name': 'Ngày cập nhật'},
    {'id': 'most_liked', 'name': 'Lượt thích'},
    {'id': 'most_viewed', 'name': 'Lượt xem'},
    {'id': 'chapter_count', 'name': 'Số chương'},
  ];

  // Định nghĩa các trạng thái
  static const List<Map<String, String>> _statusOptions = [
    {'id': 'all', 'name': 'Tất cả'},
    {'id': 'completed', 'name': 'Hoàn thành'},
    {'id': 'ongoing', 'name': 'Đang tiến hành'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown thể loại
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _genres.any((g) => g['id'] == selectedGenre) 
                    ? selectedGenre 
                    : _genres.first['id'],
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                hint: const Text('Thể loại'),
                items: _genres.map((genre) => DropdownMenuItem<String>(
                  value: genre['id'],
                  child: Text(genre['name']!),
                )).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onGenreChanged(newValue);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Dropdown sắp xếp
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _sortOptions.any((s) => s['id'] == selectedSortTag)
                    ? selectedSortTag
                    : _sortOptions.first['id'],
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                hint: const Text('Sắp xếp theo'),
                items: _sortOptions.map((sort) => DropdownMenuItem<String>(
                  value: sort['id'],
                  child: Text(sort['name']!),
                )).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onSortTagChanged(newValue);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Các nút trạng thái
          Wrap(
            spacing: 8,
            children: _statusOptions.map((status) => FilterChip(
              label: Text(
                status['name']!,
                style: TextStyle(
                  color: selectedGenre == status['id'] 
                      ? Colors.white 
                      : Colors.black,
                ),
              ),
              selected: selectedGenre == status['id'],
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey.shade200,
              onSelected: (selected) {
                if (selected) {
                  onGenreChanged(status['id']!);
                }
              },
            )).toList(),
          ),
        ],
      ),
    );
  }
}