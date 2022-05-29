import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_hive/models/note_model.dart';
import 'package:note_hive/services/db_service.dart';
class DetailController extends GetxController{
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> storeNote(BuildContext context, Notes? notes) async {
    if(notes == null) {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      update();
      if (content.isNotEmpty) {
        Notes note = Notes(
            id: content.hashCode,
            name: title,
            note: content,
            date: DateTime.now().toString().substring(0,16));
        List<Notes> noteList = DBService.loadNotes();
        noteList.add(note);
        await DBService.storeNotes(noteList);
        update();
      }
    } else {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      List<Notes> noteList = DBService.loadNotes();
      Notes note = Notes(
        id: notes.id,
        name: title,
        note: content,
        date: DateTime.now().toString().substring(0,16),
      );
      noteList.removeWhere((element) => element.id == note.id);
      update();
      if(content.isNotEmpty || title.isNotEmpty) {
        noteList.add(note);
        await DBService.storeNotes(noteList);
        update();
      }
    }
    Navigator.pop(context, true);
  }

  void loadNote(Notes? note) {
    if(note != null) {
        titleController.text = note.name!;
        contentController.text = note.note!;
        update();
    }
  }

  void clearTextField(){
    contentController.clear();
    titleController.clear();
    update();
  }
}