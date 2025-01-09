import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/components/novel_filters.dart';
import 'package:frontend/components/my_novel_card.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/novel.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MyNovelPage extends StatefulWidget {
  const MyNovelPage({super.key});

  @override
  State<MyNovelPage> createState() => _MyNovelState();
}

class _MyNovelState extends State<MyNovelPage> {
  String _selectedSortTag = 'newest';
  int? _selectedGenre;
  String _selectedStatus = "all";
  int page = 1;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      body: QueryClientBuilder(builder: (context, queryClient) {
        void onRefresh() async {
          queryClient.invalidateQueries(['novels'], exact: false);
          _refreshController.refreshCompleted();
        }

        void onLoading() async {
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
            onRefresh: onRefresh,
            onLoading: onLoading,
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
                        const Text("Truyện của tôi"),
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
                        MyNovelList(
                          sort: _selectedSortTag,
                          gene: _selectedGenre,
                          status: _selectedStatus,
                        ),
                      ]),
                )));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/upload");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyNovelList extends StatelessWidget {
  final String sort;
  final int? gene;
  final String status;

  const MyNovelList(
      {super.key,
      required this.sort,
      required this.gene,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return QueryClientBuilder(
        builder: (context, queryClient) => QueryBuilder<List<Novel>, Error>(
                ['novels', 'me', sort, gene, status],
                () => Novel.getMyNovels(sort: sort, gene: gene, status: status),
                refetchInterval: const Duration(seconds: 100),
                builder: (context, novels) {
              if (novels.isLoading) {
                return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator()),
                );
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

              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    crossAxisCount: 2),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return MyNovelCard(
                    key: Key(data[index].id.toString()),
                    novel: data[index],
                  );
                },
              );
            }));
  }
}
