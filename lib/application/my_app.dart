import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_kitchen/application/state_holder_binder.dart';

import '../presentation/screens/news_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(350, 48),
            // backgroundColor: const Color(0xff5D5CFF),
            backgroundColor: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(vertical: 10),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
      home: NewsPage(),
      initialBinding: StateHolderBinder(),
    );
  }
}
