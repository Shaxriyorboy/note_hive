import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:note_hive/models/note_model.dart';

class DBService{
  static const String dbName = "db_notes";
  static var box = Hive.box(dbName);

  static storeNotes(List<Notes> list)async{
    // Object => Map => String
    List<String> stringList = list.map((note) => jsonEncode(note.toJson())).toList();
    box.put("notes", stringList);
  }

  static List<Notes> loadNotes(){
    List<String> stringList =  box.get("notes")?? <String>[];
    //String => Map => Object
    List<Notes> noteList = stringList.map((string) => Notes.fromJson(jsonDecode(string))).toList();
    return noteList;
  }

  static Future<void> storeMode(bool isLight) async {
    await box.put("isLight", isLight);
  }

  static bool loadMode() {
    return box.get("isLight", defaultValue: true);
  }

  static removeNotes()async{
    await box.delete("notes");
  }

}