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

class _HomePageState extends State<HomePage> {
  String _selectedSortTag = 'newest';
  String _selectedGenre = 'all';

  Future<List<Novel>> getNovels() async {
    final res = await Dio().get('${dotenv.env['API_URL']}/novels');

    final data = (res.data as List)
        .map((e) => Novel.fromJson(e as Map<String, dynamic>))
        .toList();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<List<Novel>, Error>(const ['novels'], getNovels,
        builder: (content, novels) {
      if (novels.isLoading) {
        return const LinearProgressIndicator();
      }

      if (novels.isError) {
        return Text(novels.error.toString());
      }

      final data = novels.data;

      if (data == null) {
        return const Text("No result");
      }

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
              ),
              SizedBox(
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
                        title: data[index].name,
                        cover: data[index].cover,
                        chapter: data[index].name,
                        isFollowed: data[index].name == 'true',
                        onFollowChanged: (isFollowed) {},
                      ),
                    );
                  },
                ),
              ),
            ]),
          ));
    });
  }
}
