import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/models/novel_model.dart';
import '../components/novel_card.dart';
import '../components/slider.dart';
import '../components/novel_filters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

Future<List<Novel>> getNovels(
    {required String sort,
    required String gene,
    required String status}) async {
  try {
    final res = await Dio().get('${dotenv.env['API_URL']}/novels',
        queryParameters: {'sort': sort, 'gene': gene, 'status': status});

    final data = (res.data as List)
        .map((e) => Novel.fromJson(e as Map<String, dynamic>))
        .toList();

    return data;
  } catch (exception) {
    return Future.error(StateError("Lỗi không tải được dữ liệu"));
  }
}

class _HomePageState extends State<HomePage> {
  String _selectedSortTag = 'newest';
  String _selectedGenre = 'all';
  String _selectedStatus = "all";

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const MainSlider(),
            const SizedBox(height: 20),
            NovelFilters(
              selectedSortTag: _selectedSortTag,
              selectedGenre: _selectedGenre,
              selectedStatus: _selectedStatus,
              onSortTagChanged: (tag) {
                setState(() {
                  _selectedSortTag = tag;
                });
              },
              onGenreChanged: (genre) {
                setState(() {
                  _selectedGenre = genre;
                });
              },
              onStatusSelected: (status) {
                setState(() {
                  _selectedStatus = status;
                });
              },
            ),
            NovelPage(
              sort: _selectedSortTag,
              gene: _selectedGenre,
              status: _selectedStatus,
            )
          ]),
        ));
  }
}

class NovelPage extends StatelessWidget {
  final String sort;
  final String gene;
  final String status;

  const NovelPage(
      {super.key,
      required this.sort,
      required this.gene,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return QueryClientBuilder(
        builder: (context, queryClient) => QueryBuilder<List<Novel>, Error>(
                ['novels', sort, gene, status],
                () => getNovels(sort: sort, gene: gene, status: status),
                refetchInterval: const Duration(seconds: 100),
                builder: (context, novels) {
              if (novels.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (novels.isError) {
                return Center(
                    child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () =>
                            queryClient.invalidateQueries(['novels']),
                        child: const Text("Tải lại")),
                    Text(novels.error?.toString() ?? 'Lõi')
                  ],
                ));
              }

              final data = novels.data;

              if (data == null || data.isEmpty) {
                return const Text("No result");
              }

              return SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      child: NovelCard(
                        key: Key(data[index].id.toString()),
                        novel: data[index],
                        isFollowed: data[index].name == 'true',
                        onFollowChanged: (isFollowed) {},
                      ),
                    );
                  },
                ),
              );
            }));
  }
}
