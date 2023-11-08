import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workday/data/app_data.dart';
import 'package:workday/data/user_data.dart';
import 'package:workday/ui/app_page.dart';

void main() {
  runApp(MultiProvider(
      // create: (BuildContext context) => AppData.empty(),
      providers: [
        ChangeNotifierProvider(create: (context) => AppData.empty()),
        ChangeNotifierProvider(create: (context) => UserData.empty())
      ],
      child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppPage(),
    );
  }
}
