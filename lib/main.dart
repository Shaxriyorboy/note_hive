import 'package:flutter/material.dart';
import 'package:note_hive/pages/detail_page.dart';
import 'package:note_hive/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_hive/services/db_service.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox(DBService.dbName);
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      child: MyApp(),
      supportedLocales: [
        Locale("en", "US"),
        Locale("ru", "RU"),
        Locale("uz", "UZ"),
      ],
      path: "assets/translations",
      fallbackLocale: Locale("en", "US"),
    ),
  );
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
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routes: {
            HomePage.id:(context) => HomePage(),
            DetailPage.id:(context) => DetailPage(),
          },
        );
      },
    );
  }
}

