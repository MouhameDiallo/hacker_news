import 'package:hacker_news/utils/utils.dart';
import 'package:intl/intl.dart';

class Comment {
  late final int id;
  late final String? author;
  late final int parent;
  late final String text;
  late final String time;
  late  List? comments;


  Comment.fromJson(Map<String, dynamic> jsonData){
    id = jsonData["id"];
    parent = jsonData["parent"];
    author = jsonData["by"]?? '';
    text = formatText(jsonData["text"]?? '');
    time = DateFormat('dd/MM/yyyy hh:mm')
        .format(DateTime.fromMillisecondsSinceEpoch( jsonData["time"]* 1000));
    comments = jsonData['kids'];
  }
}