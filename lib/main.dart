import 'package:epub_reader_flutter_demo_task/utils/app_routes.dart';
import 'package:epub_reader_flutter_demo_task/utils/app_strings.dart';
import 'package:epub_reader_flutter_demo_task/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'bindings/home_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
    ),
  );

  await initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: epubTheme,
      initialBinding: HomeBinding(),
      home: Pages.homeView,
    );
  }
}
