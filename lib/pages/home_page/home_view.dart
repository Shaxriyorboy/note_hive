import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_hive/pages/home_page/home_controller.dart';
import 'package:note_hive/services/db_service.dart';

AppBar appBar(BuildContext context, HomeController controller) {
  return AppBar(
    backgroundColor: DBService.loadMode() ? Colors.white : Colors.black12,
    leading: controller.isAllSelected
        ? IconButton(
            icon: Icon(
              Icons.clear,
              color: DBService.loadMode() ? Colors.black54 : Colors.white,
            ),
            onPressed: () {
              controller.selectedItems();
            },
          )
        : IconButton(
            onPressed: () {
              controller.changeMode();
            },
            icon: Icon(
              DBService.loadMode() ? Icons.dark_mode : Icons.light_mode,
              color: DBService.loadMode() ? Colors.black54 : Colors.white,
            ),
          ),
    actions: [
      controller.isAllSelected
          ? IconButton(
              onPressed: () {
                controller.deleteItems();
              },
              icon: Icon(
                Icons.delete,
                color: DBService.loadMode() ? Colors.black54 : Colors.white,
              ))
          : SizedBox.shrink(),
    ],
    title: controller.isAllSelected
        ? Text(
            "${"selected note count "}${controller.count}",
            style: TextStyle(
              color: DBService.loadMode() ? Colors.black54 : Colors.white,
            ),
          )
        : Text(
            "Notes",
            style: TextStyle(
              color: DBService.loadMode() ? Colors.black : Colors.white,
            ),
          ),
    centerTitle: true,
    elevation: 0,
  );
}

Widget noteItems(
    BuildContext context, int index, HomeController controller) {
  return GestureDetector(
    onLongPress: () {
      HapticFeedback.vibrate();
      controller.firstSelected(index);
    },
    onTap: () async {
      controller.selectCount(index);
      controller.editItems(context, index);
    },
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          margin: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    controller.listNote[index].name.toString(),
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    controller.listNote[index].note.toString(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text(
                        controller.listNote[index].date.toString(),
                      ),
                      Expanded(
                        child: controller.isAllSelected &&
                                controller.listNote[index].isSelected == true
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.orange.shade500,
                              )
                            : controller.isAllSelected &&
                                    controller.listNote[index].isSelected ==
                                        false
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Checkbox(
            value: controller.listNote[index].isDone,
            onChanged: (bool? check) {
              controller.listNote[index].isDone = check!;
              controller.storeList();
              controller.update();
            },
          ),
        ),
      ],
    ),
  );
}
