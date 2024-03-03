import 'package:hacker_news/utils/utils.dart';
import 'package:intl/intl.dart';

const String columnId = '_id';
const String columnTitle = 'title';
const String columnTime = 'time';
const String columnUrl = 'url';
const String columnScore = 'score';
const String columnAuthor = 'author';
const String columnFav = 'fav';


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
    title = formatText(jsonData["title"]??'');
    url = jsonData["url"];
    time = DateFormat('dd/MM/yyyy hh:mm')
        .format(DateTime.fromMillisecondsSinceEpoch( jsonData["time"]* 1000));
    score = jsonData['score']??0;
    comments = jsonData['kids'];
    isFavorite = false;
  }

  Story.fromMap(Map<String, Object?> map) {
    id = map[columnId]as int;
    title = map[columnTitle] as String;
    time = map[columnTime] as String;
    author = map[columnAuthor] as String;
    score = map[columnScore] as int;
    url = map[columnUrl]==null? '':map[columnUrl] as String;
    isFavorite = map[columnFav] as int ==1;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnTime: time,
      columnAuthor: author,
      columnUrl: url,
      columnScore: score,
      columnFav: isFavorite?1:0
    };
    map[columnId] = id;
      return map;
  }

}
