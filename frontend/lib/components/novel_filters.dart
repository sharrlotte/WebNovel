import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/models/category.dart';
import 'package:frontend/models/query.dart';
import 'package:frontend/utils.dart';

class NovelFilters extends StatelessWidget {
  final String selectedSortTag;
  final String selectedStatus;
  final int? selectedGenre;
  final Function(int?) onGenreChanged;
  final Function(String) onSortTagChanged;
  final Function(String) onStatusSelected;

  Future<List<Category>> getCategories() async {
    return catchError(() async {
      final res = await getApi().get(
        '${dotenv.env['API_URL']}/categories',
      );

      final data = (res.data as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();

      return data;
    });
  }

  const NovelFilters(
      {super.key,
      required this.selectedSortTag,
      required this.selectedGenre,
      required this.onSortTagChanged,
      required this.onGenreChanged,
      required this.selectedStatus,
      required this.onStatusSelected});

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
        const ['categories'], //
        getCategories, //
        builder: (context, categories) {
      List<Category> data = categories.isLoading
          ? []
          : categories.isError
              ? []
              : categories.data == null
                  ? []
                  : categories.data ?? [];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
                child: DropdownButton<int>(
                  value: data.any((g) => g.id == selectedGenre)
                      ? selectedGenre
                      : null,
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  hint: const Text('Tất cả'),
                  items: data
                      .map((genre) => DropdownMenuItem<int>(
                            value: genre.id,
                            child: Text(genre.name),
                          ))
                      .toList(),
                  onChanged: (int? newValue) {
                    if (newValue == selectedGenre) {
                      onGenreChanged(null);
                    } else {
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
                  value: sorts.any((s) => s['id'] == selectedSortTag)
                      ? selectedSortTag
                      : sorts.first['id'],
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  hint: const Text('Sắp xếp theo'),
                  items: sorts
                      .map((sort) => DropdownMenuItem<String>(
                            value: sort['id'],
                            child: Text(sort['name']!),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onSortTagChanged(newValue);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: status
                  .map((status) => FilterChip(
                        label: Text(
                          status['name']!,
                          style: TextStyle(
                            color: selectedStatus == status['id']
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: selectedStatus == status['id'],
                        selectedColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.grey.shade200,
                        checkmarkColor: Colors.white,
                        onSelected: (selected) {
                          if (selected) {
                            onStatusSelected(status['id']!);
                          }
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      );
    });
  }
}
