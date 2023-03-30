import 'package:flutter/material.dart';
import 'package:jarvis/colors.dart';
import 'package:jarvis/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jarvis',
      theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Pallete.backgroundColor,
          appBarTheme:
              const AppBarTheme(backgroundColor: Pallete.backgroundColor)),
      home: const HomePage(),
    );
  }
}
