import 'package:Socraticos/widgets/navbar.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:flutter/material.dart';

final Color profileBlue = const Color(0xffB5F8FF);
final double verticalSpacing = 20;

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: verticalSpacing),
            child: Text("Search", style: titleStyle(48))),
        SizedBox(
          height: verticalSpacing,
        ),
        searchBox(context)

      ],

    );
  }
}

Widget searchBox(BuildContext context) {
  return Center(
    child: Container(
        alignment: Alignment.center,
        width: 300,
        height: 60,
        child: Text("Enter keywords", style: titleStyle(18),),
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(25),
          color: profileBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3, // changes position of shadow
            ),
          ],
        )),
  );
}


