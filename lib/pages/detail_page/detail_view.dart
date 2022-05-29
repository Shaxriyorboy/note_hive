import 'package:flutter/material.dart';
import 'package:note_hive/models/note_model.dart';
import 'package:note_hive/pages/detail_page/detail_controller.dart';
import 'package:get/get.dart';

Container textFieldItem(var controller,String hintText) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    child: TextFormField(
      style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold),
      controller: controller,
      decoration: InputDecoration(
        isCollapsed: false,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      cursorColor: Colors.orange,
      textAlignVertical: TextAlignVertical.center,
    ),
  );
}


AppBar appBarForDetailPage(DetailController controller, BuildContext context,Notes? notes) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: IconButton(
      onPressed: () {
        controller.clearTextField();
        Get.back();
      },
      icon: Icon(
        Icons.arrow_back_sharp,
        color: Colors.black,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          controller.storeNote(context,notes);
          controller.clearTextField();
        },
        child: Text("Save"),
      ),
    ],
  );
}