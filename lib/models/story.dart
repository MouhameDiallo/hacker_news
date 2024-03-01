import 'package:intl/intl.dart';

class Story {
  late int id;
  late String author;
  late String title;
  String? url;
  late String time;
  late int score; // nombre de commentaires
  List<dynamic>? comments;
  late bool isFavorite;

  Story.fromJson(Map<String, dynamic> jsonData){
    id = jsonData["id"];
    author = jsonData["by"];
    title = jsonData["title"]??'';
    url = jsonData["url"];
    time = DateFormat('dd/MM/yyyy hh:mm')
        .format(DateTime.fromMillisecondsSinceEpoch( jsonData["time"]* 1000));
    score = jsonData['score']??0;
    comments = jsonData['kids'];
    isFavorite = false;
  }
}
