import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:note_hive/models/note_model.dart';
import 'package:note_hive/pages/detail_page.dart';
import 'package:note_hive/services/db_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  bool isAllSelected = false;
  List<Notes> listNote = [];
  bool isLight = true;

  void loadNoteList() {
    setState(() {
      listNote = DBService.loadNotes();
    });
    listNote.sort((a, b) => b.date!.compareTo(a.date!));
  }

  void _openDetailPage() async {
    var result = await Navigator.of(context).pushNamed(DetailPage.id);
    if (result == true) {
      setState(() {
        loadNoteList();
        _storeList();
      });
    }
  }

  void _changeMode() {
    setState(() {
      isLight = !isLight;
    });
    DBService.storeMode(isLight);
  }

  void loadMode() async {
    isLight = DBService.loadMode();
  }

  void _storeList() async {
    DBService.storeNotes(listNote);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNoteList();
    _storeList();
    loadMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DBService.loadMode()?Colors.white:Colors.black12,
        leading: isAllSelected
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: DBService.loadMode()?Colors.black54:Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    count = 1;
                    isAllSelected = false;
                    for (var item in listNote) {
                      item.isSelected = false;
                    }
                  });
                },
              )
            : IconButton(
                onPressed: () {
                  DBService.storeMode(!DBService.loadMode());
                  setState(() {});
                },
                icon: Icon(
                    DBService.loadMode() ? Icons.dark_mode : Icons.light_mode,color: DBService.loadMode()?Colors.black54:Colors.white,),
              ),
        actions: [
          isAllSelected
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      count = 1;
                      isAllSelected = false;
                      listNote
                        .removeWhere((element) => element.isSelected == true);
                      _storeList();
                      // listNote = DBService.loadNotes();
                      // loadNoteList();
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: DBService.loadMode()?Colors.black54:Colors.white,
                  ))
              : SizedBox.shrink(),
          IconButton(
            onPressed: () {},
            icon: SpeedDial(
              direction: SpeedDialDirection.down,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 30.0),
              elevation: 0,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: CircleBorder(),
              children: [
                SpeedDialChild(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/img.png"),
                    ),
                    label: 'Russian',
                    labelStyle: TextStyle(fontSize: 16),
                    onTap: () {
                      context.locale = Locale("ru", "RU");
                    }),
                SpeedDialChild(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/img_1.png"),
                    ),
                    label: 'English',
                    labelStyle: TextStyle(fontSize: 16),
                    onTap: () {
                      context.locale = Locale("en", "US");
                    }),
                SpeedDialChild(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/img_2.png"),
                    ),
                    label: 'Uzbek',
                    labelStyle: TextStyle(fontSize: 16),
                    onTap: () {
                      context.locale = Locale("uz", "UZ");
                    }),
              ],
            ),
          ),
        ],
        title: isAllSelected
            ? Text(
                "$count${"selected".tr()}",
                style: TextStyle(color: DBService.loadMode()?Colors.black54:Colors.white,),
              )
            : Text(
                "app name".tr(),
                style: TextStyle(color: DBService.loadMode()?Colors.black:Colors.white,),
              ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 200,
            ),
            itemCount: listNote.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  HapticFeedback.vibrate();
                  setState(() {
                    count = 1;
                    isAllSelected = true;
                    listNote[index].isSelected = true;
                  });
                },
                onTap: () async {
                  setState(() {
                    if (isAllSelected && listNote[index].isSelected == true) {
                      listNote[index].isSelected = false;
                      count--;
                    } else if (isAllSelected &&
                        listNote[index].isSelected == false) {
                      listNote.elementAt(index).isSelected = true;
                      count++;
                    }
                  });

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
                },
                child: Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            listNote[index].name.toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            listNote[index].note.toString(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Text(
                                listNote[index].date.toString(),
                              ),
                              Expanded(
                                child: isAllSelected &&
                                        listNote[index].isSelected == true
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.orange.shade500,
                                      )
                                    : isAllSelected &&
                                            listNote[index].isSelected == false
                                        ? Icon(
                                            Icons.circle,
                                            color: Colors.grey.shade300,
                                          )
                                        : SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade500,
        onPressed: () {
          _openDetailPage();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
