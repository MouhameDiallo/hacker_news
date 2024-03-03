import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hacker_news/networking/hacker_news_api.dart';
import 'package:hacker_news/utils/database/database_helper.dart';
import 'package:hacker_news/utils/providers/story_provider.dart';
import 'package:hacker_news/utils/utils.dart';
import 'package:hacker_news/widgets/news_tile.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper db = DatabaseHelper();
    db.init();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChangeNotifierProvider(
                create: (BuildContext context) {
                  return StoryProvider();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FutureBuilder(
                      future: HackerNewsApi.getTopStories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SpinKitDualRing(
                            color: Colors.blueAccent,
                            size: 50,
                          );
                        } else {
                          List<int> indexes = snapshot.data!;
                          if(isFirstDayOfMonth()){
                            db.monthlyCleaning(indexes);
                          }
                          return FutureBuilder(
                              future: HackerNewsApi.fetchStories(indexes,db),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Consumer<StoryProvider>(
                                      builder: (context, value, _) {
                                    value.stories = snapshot.data!;
                                    return ListView.builder(
                                        itemCount: value.stories.length,
                                        itemBuilder: (BuildContext context,
                                            int position) {

                                          return NewsTile(
                                            story: value.stories[position],
                                            position: position,
                                            isFav: value
                                                .stories[position].isFavorite,
                                          );
                                        });
                                  });
                                } else {
                                  return const SpinKitCubeGrid(
                                    color: Colors.blueAccent,
                                  );
                                }
                              });
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
