import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hacker_news/utils/database/database_helper.dart';
import 'package:http/http.dart' as http;
import '../models/comment.dart';
import '../models/story.dart';
// Lien api: https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty

class HackerNewsApi {
  static Future<List<int>> getTopStories() async {
    try{
      var response = await http
          .get(Uri.parse('https://hacker-news.firebaseio.com/v0/topstories.json'))
          .timeout(const Duration(seconds: 10));
      String returnType = response.body;
      List<String> returnStringList = returnType.substring(1, returnType.length-1).split(',');
      List<int> returnIntList = [];
      //pour des raisons de performances de stockage
      for(String element in returnStringList){
        returnIntList.add(int.parse(element));
      }
      return returnIntList.sublist(0,75);
    }
    on TimeoutException{
      print('Time out Exception my boy');
    }
    catch(e){
      print('Unknown error boy: ');
    }
    return [];
  }

  static Future<Story?> fetchAStory(int id) async{
    Story story;
    try{
      var response = await http
          .get(Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty'))
          .timeout(const Duration(seconds: 10));
      Map<String,dynamic> responseBody = jsonDecode(response.body);
      story = Story.fromJson(responseBody);
      print('id -> $id');
      return story;
    }
    on TimeoutException{
      if(kDebugMode){
        print('Time out Exception: the fetching of data from the API took too long');
      }
    }
    catch(e,s){
      if (kDebugMode) {
        print('Unknown error boy: ');
        print(e);
        print(s);
      }
    }
    return null ;
  }

  static Future<List<Story>> fetchStories(List<int> indexes, DatabaseHelper db) async{
    List<Story> stories = [];
    List<int> list = await db.getAllIds();

    try{
      for (int index in indexes){

        Story? story;
        if(list.contains(index)){
          story = await db.getAllStories(index);
        }
        else{
          story = await fetchAStory(index);
          await db.insertStories(story!);
        }
        if(story!=null){
          stories.add(story);
        }
      }
      return stories;
    }
    catch(e,s){
      if (kDebugMode) {
        print('Unknown error: ');
        print(e);
        print(s);
      }
    }
    return stories ;
  }

  static Future<Comment?> fetchAComment(int id) async{
    Comment comment;
    try{
      var response = await http
          .get(Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty'))
          .timeout(const Duration(seconds: 10));
      Map<String,dynamic> responseBody = jsonDecode(response.body);
      comment = Comment.fromJson(responseBody);

      return comment;
    }
    on TimeoutException{
      if(kDebugMode){
        print('Time out Exception: the fetching of data from the API took too long');
      }
    }
    catch(e,s){
      if (kDebugMode) {
        print('Unknown error boy: ');
        print(e);
        print(s);
      }

    }

    return null ;
  }

  static Future<List> getComments(int id)async{
    List comments =[];
    Story? story = await fetchAStory(id);
    if(story!=null && story.comments!=null){
      comments = story.comments!;
    }
    return comments;
  }

}
