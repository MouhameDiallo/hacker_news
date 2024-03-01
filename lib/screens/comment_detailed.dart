import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hacker_news/models/comment.dart';

import '../networking/hacker_news_api.dart';
import '../widgets/single_comment_widget.dart';

class CommentDetailed extends StatelessWidget {
  final Comment comment;
  const CommentDetailed({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    comment.text,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            //-------------
            Container(
              margin: const EdgeInsets.all(15.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '${comment.author} | ${comment.time}',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
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
            comment.comments == null
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
                  itemCount: comment.comments!.length,
                  itemBuilder: (context, position) {
                    return FutureBuilder(
                        future: HackerNewsApi
                            .fetchAComment(comment.comments![position]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleComment(
                                comment: snapshot.data!);
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
    );
  }
}
