import 'package:flutter/material.dart';
import 'package:note_hive/pages/detail_page/detail_page.dart';
import 'package:note_hive/pages/home_page/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_hive/services/db_service.dart';
import 'package:note_hive/services/di_service.dart';

void main() async{
  await DIService.init();
  await Hive.initFlutter();
  await Hive.openBox(DBService.dbName);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: DBService.box.listenable(),
      builder: (context,box,widget) {
        return MaterialApp(
          themeMode: DBService.loadMode() ? ThemeMode.light: ThemeMode.dark,
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
          routes: {
            HomePage.id:(context) => HomePage(),
            DetailPage.id:(context) => DetailPage(),
          },
        );
      },
    );
  }
}

