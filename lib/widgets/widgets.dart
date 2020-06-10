import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color appBarBlue = const Color(0xffA6E3E9);
final Color background = const Color(0xffE3FDFD);

Widget appBarMain(BuildContext context) {
  return AppBar(title: Text("Socraticos"), backgroundColor: appBarBlue);
}

Widget homeBar(BuildContext context) {
  return AppBar(title: Text("Socraticos"), backgroundColor: appBarBlue);
}

TextStyle titleStyle(double size) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
        color: Colors.black, fontSize: size, fontWeight: FontWeight.bold),
  );
}

Widget bottomBar(BuildContext context) {
  return BottomAppBar(
    color: appBarBlue,
    child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {},
          )
        ]),
  );
}

class BotIcon {}
