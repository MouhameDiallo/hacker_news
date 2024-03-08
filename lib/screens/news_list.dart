import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hacker_news/networking/hacker_news_api.dart';
import 'package:hacker_news/utils/utils.dart';
import 'package:hacker_news/widgets/news_tile.dart';
import 'package:provider/provider.dart';

import '../database/database_helper.dart';
import '../providers/story_provider.dart';

// pour verifier s'il y'a la connexion à internet
Future<bool> hasDeviceInternet() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  bool value = connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.mobile;
  return value;
}

class NewsList extends StatelessWidget {
  final bool onlyFavorite;
  const NewsList({super.key, this.onlyFavorite=false});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper db = DatabaseHelper();
    db.init();

    Future<List<int>> getStories()async{
      await db.init();
      final hasInternet = await hasDeviceInternet();
      if(onlyFavorite){
        return await db.getFavIds();
      }
      if(hasInternet){
        return await HackerNewsApi.getTopStories();
      }
      else{
        return await db.getAllIds();
      }
    }

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
                      future: getStories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SpinKitDualRing(
                            color: Colors.blueAccent,
                            size: 50,
                          );
                        } else {
                          List<int> indexes = snapshot.data!;
                          if (isFirstDayOfMonth()) {
                            db.monthlyCleaning(indexes).then((value){
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Cleaning done!',
                                  message:
                                  'Story list updated!',
                                  contentType: ContentType.help,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            });
                          }
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  const CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: NetworkImage(
                                        'https://t3.ftcdn.net/jpg/06/18/64/62/240_F_618646245_OuZrVlHoeivQEFuEDX9fd5UO1xpkjlkp.jpg'),
                                  ),
                                  const SizedBox(
                                    width: 30.0,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextField(
                                        onChanged: (val) {
                                          final provider = Provider.of<StoryProvider>(context, listen: false);
                                          provider.searching(val);
                                        },
                                        decoration: const InputDecoration(
                                            hintText: 'Search...',
                                            hintStyle: TextStyle(
                                              color: Colors.blueGrey,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            suffixIcon: Icon(Icons.search)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: FutureBuilder(
                                    future: HackerNewsApi.fetchStories(indexes, db),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Consumer<StoryProvider>(
                                            builder: (context, value, _) {
                                              value.stories = snapshot.data!;
                                              value.initializing(snapshot.data!);
                                              value.subList.isNotEmpty? value.stories = value.subList:value.stories = value.initialList;
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
                                    }),
                              ),
                            ],
                          );
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
