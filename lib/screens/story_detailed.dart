import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hacker_news/models/comment.dart';
import 'package:hacker_news/models/story.dart';
import 'package:hacker_news/networking/hacker_news_api.dart';
import 'package:hacker_news/widgets/single_comment_widget.dart';

class StoryDetailed extends StatelessWidget {
  final Story story;
  const StoryDetailed({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
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
              story.comments == null
                  ? Container(
                margin: const EdgeInsets.all(24.0),
                child: const Center(
                  child: Text("Aucun commentaire",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blueGrey,
                    fontStyle: FontStyle.italic,
                  ),),
                ),
              )
                  : SizedBox(
                      height: 220,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: story.comments!.length,
                          itemBuilder: (context, position) {
                            return FutureBuilder(
                                future: HackerNewsApi
                                    .fetchAComment(story.comments![position]),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Comment comment = snapshot.data!;
                                    return comment.text!=''?SingleComment(
                                        comment: snapshot.data!):Container();
                                  } else {
                                    return const SpinKitCubeGrid(
                                      color: Colors.blueAccent,
                                    );
                                  }
                                });
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
