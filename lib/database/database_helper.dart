import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/story.dart';

const String columnId = '_id';
const String columnTitle = 'title';
const String columnTime = 'time';
const String columnUrl = 'url';
const String columnScore = 'score';
const String columnAuthor = 'author';
const String tableHackerNews = 'hnTable';
const String columnFav = 'fav';

class DatabaseHelper {
  late Database db;

  Future<void>init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "news_db");
    db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    String request = '''
      create table $tableHackerNews ( 
      $columnId integer primary key autoincrement, 
      $columnTitle text not null,
      $columnAuthor varchar(25) not null,
      $columnTime varchar(20) not null,
      $columnScore int not null,
      $columnUrl varchar(50),
      $columnFav int not null
      );
    ''';
    print('Ok Creation');
    await db.execute(request);
  }

  Future<int> insertStories(Story story) async {
    return await db.insert(tableHackerNews, story.toMap());
  }

  Future<Story?> getAllStories(int id) async {
    // return db.query("Tablename
    List<Map<String, dynamic>> maps = await db.query(tableHackerNews,
        columns: [
          columnId,
          columnTitle,
          columnAuthor,
          columnScore,
          columnUrl,
          columnTime,
          columnFav
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Story.fromMap(maps.first);
    }
    return null;
  }

  List<int> listFromMap(List<Map<String,dynamic>> mapList){
    //hello
    List<int> list =[];
    for (var x in mapList){
      int value = x[columnId] ;
      //print('From map list: $value');
      list.add(value);
    }
    return list;
  }

  Future<List<int>> getAllIds() async {
    // return db.query("Tablename
    List<Map<String, dynamic>> maps = await db.query(tableHackerNews,
        columns: [
          columnId,
        ],);
    return listFromMap(maps);
  }

  Future<List<int>> getFavIds() async {
    List<Map<String, dynamic>> maps = await db.query(tableHackerNews,
      columns: [
        columnId,
      ],
        where: '$columnFav = 1',
    );
    return listFromMap(maps);
  }

  Future<bool> isInDatabase(int x)async{
    return (await getAllIds()).contains(x);
  }

  Future<int> delete(int id) async {
    return await db.delete(tableHackerNews, where: '$columnId = ?', whereArgs: [id]);
  }

  void monthlyCleaning(List fetchedIndexes)async{
    List<int> databaseIds = await getAllIds();
    for(int i in databaseIds){
      if(!fetchedIndexes.contains(i)){
        Story? story = await getAllStories(i);
        if(story!= null){
          if (story.isFavorite==false) delete(i);
        }
      }
    }
  }

  Future<int> update(Story story) async {
    print(story.isFavorite);
    return await db.update(tableHackerNews, story.toMap(),
        where: '$columnId = ?', whereArgs: [story.id]);
  }
  Future close() async => db.close();
}
