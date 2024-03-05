import 'package:flutter/foundation.dart';
import 'package:hacker_news/networking/hacker_news_api.dart';

class CommentProvider extends ChangeNotifier{
  List comments = [];
  bool test = true;

  void loadComments(int storyId) async{
    List x = await HackerNewsApi.getComments(storyId);
    for(var i in x) {
      comments.add(i);
    }
    print('Loaded: $comments');
    test = !test;
    notifyListeners();
  }
}