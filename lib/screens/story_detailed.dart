import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hacker_news/models/comment.dart';
import 'package:hacker_news/models/story.dart';
import 'package:hacker_news/networking/hacker_news_api.dart';
import 'package:hacker_news/widgets/single_comment_widget.dart';
import 'package:provider/provider.dart';

import '../providers/comment_provider.dart';

class StoryDetailed extends StatelessWidget {
  final Story story;
  const StoryDetailed({super.key, required this.story});

  Future<bool> isConnected() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 40.0,
                child: Text(story.author.characters.first),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                '${story.author} | ${story.time}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Card(
                margin: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        story.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${story.score}'),
                        const Icon(Icons.star),
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Commentaires',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return CommentProvider();
                },
                child: Consumer<CommentProvider>(
                  builder: (BuildContext context, CommentProvider value, _) {
                    return value.comments.isEmpty
                        ? Container(
                            margin: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        isConnected().then((value) {
                                          if (value) {
                                            final itemProvider =
                                                Provider.of<CommentProvider>(
                                                    context,
                                                    listen: false);
                                            itemProvider.loadComments(story.id);
                                          } else {
                                            final snackBar = SnackBar(
                                              elevation: 0,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'No Internet!',
                                                message:
                                                    'Check your internet connectivity!',
                                                contentType:
                                                    ContentType.failure,
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                          }
                                        });
                                      },
                                      child: const Text('Load comments', style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        decorationStyle: TextDecorationStyle.dashed,
                                      ),),
                                    )
                                  ],
                                ),
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 18.0),
                                    child: Text(
                                      "No comment",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.blueGrey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: value.comments.length,
                              itemBuilder: (context, position) {
                                return FutureBuilder(
                                  future: HackerNewsApi.fetchAComment(
                                      value.comments[position]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Comment comment = snapshot.data!;
                                      return comment.text != ''
                                          ? SingleComment(
                                              comment: snapshot.data!)
                                          : Container();
                                    } else {
                                      return const SpinKitCubeGrid(
                                        color: Colors.blueAccent,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
