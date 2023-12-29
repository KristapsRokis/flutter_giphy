//main
import 'package:flutter/material.dart';
import 'package:flutter_giphy/giphy_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Giphy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GiphyPage(),
    );
  }
}

