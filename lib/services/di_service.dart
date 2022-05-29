import 'package:get/get.dart';
import 'package:note_hive/pages/detail_page/detail_controller.dart';
import 'package:note_hive/pages/home_page/home_controller.dart';
class DIService{
  static Future<void> init()async{
    Get.lazyPut<DetailController>(() => DetailController(), fenix:  true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix:  true);
  }
}