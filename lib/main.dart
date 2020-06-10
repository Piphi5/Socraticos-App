import 'package:Socraticos/views/UserProfile.dart';
import 'package:Socraticos/views/chats.dart';
import 'package:Socraticos/widgets/navbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socraticos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        accentColor: Colors.white,
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NavigationBar(),
    );
  }
}
