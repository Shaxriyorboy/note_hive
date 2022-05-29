import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_hive/models/note_model.dart';
import 'package:note_hive/pages/detail_page/detail_page.dart';
import 'package:note_hive/services/db_service.dart';
class HomeController extends GetxController{
  int count = 0;
  bool isAllSelected = false;
  List<Notes> listNote = [];
  bool isLight = true;

  @override
  void onInit() {
    // TODO: implement initState
    super.onInit();
    loadNoteList();
    storeList();
    loadMode();
  }

  void loadNoteList() {
      listNote = DBService.loadNotes();
    listNote.sort((a, b) => b.date!.compareTo(a.date!));
    update();
  }

  void openDetailPage(BuildContext context) async {
    var result = await Navigator.of(context).pushNamed(DetailPage.id);
    if (result == true) {
        loadNoteList();
        storeList();
        update();
    }
  }

  void changeMode() {
    DBService.storeMode(!DBService.loadMode());
    update();
  }

  void loadMode() async {
    isLight = DBService.loadMode();
    update();
  }

  void storeList() async {
    DBService.storeNotes(listNote);
    update();
  }

  void selectedItems(){
    count = 1;
    isAllSelected = false;
    for (var item in listNote) {
      item.isSelected = false;
    }
    update();
  }

  void firstSelected(int index){
    count = 1;
    isAllSelected = true;
    listNote[index].isSelected = true;
    update();
  }

  void selectCount(int index){
    if (isAllSelected && listNote[index].isSelected == true) {
      listNote[index].isSelected = false;
      count--;
      update();
    } else if (isAllSelected &&
        listNote[index].isSelected == false) {
      listNote.elementAt(index).isSelected = true;
      count++;
      update();
    }
  }

  void deleteItems(){
    count = 1;
    isAllSelected = false;
    listNote
        .removeWhere((element) => element.isSelected == true);
    storeList();
    update();
  }

  void editItems(BuildContext context,int index)async{
    if (!isAllSelected) {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(
                note: listNote[index],
              )));
      if (result != null && result == true) {
        loadNoteList();
      }
    }
  }
}