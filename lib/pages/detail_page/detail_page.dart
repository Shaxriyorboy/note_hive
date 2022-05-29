import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_hive/models/note_model.dart';
import 'package:note_hive/pages/detail_page/detail_controller.dart';
import 'package:note_hive/pages/detail_page/detail_view.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  Notes? note;
  DetailPage({Key? key,this.note}) : super(key: key);
  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  void initState() {
    super.initState();
    Get.find<DetailController>().loadNote(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailController>(
      init: DetailController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: ()async{
            controller.storeNote(context,widget.note!);
            controller.clearTextField();
            return true;
          },
          child: Scaffold(
            appBar: appBarForDetailPage(controller, context,widget.note),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                textFieldItem(controller.titleController,"Title"),
                textFieldItem(controller.contentController,"Content"),
              ],
            ),
          ),
        );
      }
    );
  }
}
