import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/components/novel_card.dart';
import 'package:frontend/models/novel.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: QueryClientBuilder(
            builder: (context, queryClient) => QueryBuilder<List<Novel>, Error>(
                    const ['novels', 'favorites'],
                    () => Novel.getFavoritesNovels(),
                    refetchInterval: const Duration(seconds: 100),
                    builder: (context, data) {
                  var novels = data.data;

                  if (data.isError) {
                    return Center(
                        child: Column(
                      children: [
                        Text(data.error?.toString() ?? 'Lõi'),
                        ElevatedButton(
                            onPressed: () =>
                                queryClient.invalidateQueries(['novels']),
                            child: const Text("Tải lại")),
                      ],
                    ));
                  }

                  if (data.isLoading) {
                    return const Center(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator()),
                    );
                  }

                  if (novels == null || novels.isEmpty) {
                    return const Text("Không có novel");
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            crossAxisCount: 2),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: novels.length,
                    itemBuilder: (context, index) {
                      return NovelCard(
                        key: Key(novels[index].id.toString()),
                        novel: novels[index],
                      );
                    },
                  );
                })));
  }
}
