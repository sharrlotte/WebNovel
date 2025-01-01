import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/models/novel.dart';
import '../components/novel_card.dart';
import '../components/slider.dart';
import '../components/novel_filters.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedSortTag = 'newest';
  int? _selectedGenre;
  String _selectedStatus = "all";

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return QueryClientBuilder(builder: (context, queryClient) {
      void _onRefresh() async {
        queryClient.invalidateQueries(['novels']);
        _refreshController.refreshCompleted();
      }

      void _onLoading() async {
        await Future.delayed(Duration(milliseconds: 1000));
        if (mounted) setState(() {});
        _refreshController.loadComplete();
      }

      return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: CustomHeader(
              builder: (BuildContext context, RefreshStatus? mode) {
            Widget body;

            if (mode == RefreshStatus.idle) {
              body = const Text("Kéo lên để làm mới");
            } else if (mode == RefreshStatus.refreshing) {
              body = const CupertinoActivityIndicator();
            } else if (mode == RefreshStatus.failed) {
              body = const Text("Làm mới thất bải");
            } else if (mode == RefreshStatus.canRefresh) {
              body = const Text("Thả để tải thêm");
            } else if (mode == RefreshStatus.completed) {
              body = const Text("Tải lại thành công");
            } else {
              body = const Text("Không còn dữ liệu");
            }

            return Center(child: body);
          }),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;

              if (mode == LoadStatus.idle) {
                body = const Text("Kéo lên để làm mới");
              } else if (mode == LoadStatus.loading) {
                body = const CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = const Text("Làm mới thất bải");
              } else if (mode == LoadStatus.canLoading) {
                body = const Text("Thả để tải thêm");
              } else {
                body = const Text("Không còn dữ liệu");
              }

              return Center(child: body);
            },
          ),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
              )));
    });
  }
}

class NovelPage extends StatelessWidget {
  final String sort;
  final int? gene;
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
                () => Novel.getNovels(sort: sort, gene: gene, status: status),
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
                        onFollowChanged: (isFollowed) {},
                      ),
                    );
                  },
                ),
              );
            }));
  }
}
