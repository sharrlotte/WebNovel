import 'package:flutter/material.dart';

class Paginator extends StatelessWidget {
  final int page;
  final int size;
  final int maxSize;

  final Function(int) onPageChanged;

  Paginator(
      {super.key,
      required this.page,
      required this.size,
      required this.maxSize,
      required this.onPageChanged}) {}

  @override
  Widget build(BuildContext context) {
    final hasNextPage = size == maxSize;
    final hasPreviousPage = page > 1;

    return Row(
      children: [
        hasPreviousPage
            ? Expanded(
                child: ElevatedButton(
                onPressed: () {
                  onPageChanged(page - 1);
                },
                child: Text('Quay lại'),
              ))
            : Container(),
        const SizedBox(width: 8),
        hasNextPage
            ? Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onPageChanged(page + 1);
                  },
                  child: Text('Load thêm'),
                ),
              )
            : Container(),
        const SizedBox(width: 8),
        page != 1
            ? ElevatedButton(
                onPressed: () {
                  onPageChanged(1);
                },
                child: Text('Quay về đầu'),
              )
            : Container(),
      ],
    );
  }
}
