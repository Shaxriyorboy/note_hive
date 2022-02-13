import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_hive/models/note_model.dart';
import 'package:note_hive/services/db_service.dart';

class DetailPage extends StatefulWidget {
  Notes? note;
  DetailPage({Key? key,this.note}) : super(key: key);
  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> _storeNote() async {
    if(widget.note == null) {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      if (content.isNotEmpty) {
        Notes note = Notes(
            id: content.hashCode,
            name: title,
            note: content,
            date: DateTime.now().toString().substring(0,16));
        List<Notes> noteList = DBService.loadNotes();
        noteList.add(note);
        await DBService.storeNotes(noteList);
      }
    } else {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      List<Notes> noteList = DBService.loadNotes();
      Notes note = Notes(
        id: widget.note!.id,
        name: title,
        note: content,
        date: DateTime.now().toString().substring(0,16),
      );
      noteList.removeWhere((element) => element.id == note.id);
      if(content.isNotEmpty || title.isNotEmpty) {
        noteList.add(note);
        await DBService.storeNotes(noteList);
      }
    }
    Navigator.pop(context, true);
  }

  void loadNote(Notes? note) {
    if(note != null) {
      setState(() {
        titleController.text = note.name!;
        contentController.text = note.note!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadNote(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        _storeNote();
        setState(() {
          contentController.clear();
          titleController.clear();
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_sharp,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _storeNote();
                setState(() {
                  contentController.clear();
                  titleController.clear();
                });
              },
              child: Text("Save"),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                controller:titleController,
                decoration: const InputDecoration(
                  isCollapsed: false,
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                cursorColor: Colors.orange,
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: TextFormField(
                style: TextStyle(fontSize: 15,),
                controller:contentController,
                decoration: InputDecoration(
                  isCollapsed: false,
                  hintText: "Content",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                cursorColor: Colors.orange,
                showCursor: true,
                textAlignVertical: TextAlignVertical.center,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
