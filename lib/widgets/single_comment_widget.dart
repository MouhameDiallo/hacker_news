import 'package:flutter/material.dart';
import 'package:hacker_news/screens/comment_detailed.dart';

import '../models/comment.dart';

class SingleComment extends StatelessWidget {
  final Comment comment;
  const SingleComment({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Go to comment details
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return CommentDetailed(comment: comment);
          }),
        );
      },
      child: SizedBox(
        width: 150.0,
        child: Card(
          color: Colors.blueGrey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  comment.text.length < 100
                      ? '"${comment.text}"'
                      : '"${comment.text.substring(0, 100)}..."',
                  style: const TextStyle(fontSize: 14.0, color: Colors.white,fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                comment.author!=null ? comment.author! : '',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
