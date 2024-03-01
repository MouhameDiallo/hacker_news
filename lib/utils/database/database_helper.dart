import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  late Database db;

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,"news_db");
    openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db,int version) async {
    // String request = "CREATE TABLE ;";
    // await db.execute(request);
  }

  Future<int>_insertStories( enregisrement) async{
    //faire un tour sur FlushBar
    // return await db.insert(NomTable,enregistrement)
    return 0;
  }

  Future<int> getAllStories() async{
    // return db.query("Tablename

    return 0;
  }
}