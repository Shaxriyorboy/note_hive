import 'package:flutter/material.dart';
import 'package:note_hive/pages/home_page/home_controller.dart';
import 'package:note_hive/pages/home_page/home_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: appBar(context,controller),
          body: controller.listNote.isNotEmpty?Container(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 200,
                ),
                itemCount: controller.listNote.length,
                itemBuilder: (context, index) {
                  return noteItems(context,index,controller);
                }),
          ): Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/lottie_anim/home_lottie.json"),
              Text("Add Note...",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange.shade500,
            onPressed: () {controller.openDetailPage(context);
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      }
    );
  }
}
