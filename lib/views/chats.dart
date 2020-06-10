import 'package:Socraticos/widgets/navbar.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:flutter/material.dart';

final Color chatBlue = const Color(0xff71C9CE);
final double verticalSpacing = 20;

List<String> membersTest = ["Breh", "Pooj", "Nation", "APCS", "Yuh", "Clean"];

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: [

          SliverAppBar(
            pinned: false,
            expandedHeight: 250,
            backgroundColor: Color(0xffCBF1F5),
            flexibleSpace: Container(
              alignment: Alignment.centerLeft,
              child: FlexibleSpaceBar(
                titlePadding: EdgeInsets.all(10),
                title: Container(
                  alignment: Alignment.bottomLeft,
                    child: Text("My\nSocraticos", style: titleStyle(48),))),
            ),
          ),

          SliverFixedExtentList(

            itemExtent: 225,
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Center(
                        child: ChatDisplay(context, index.toString(), "bre", membersTest),
                  );
                },
              childCount: membersTest.length
            ),

          )


        ],


    );
  }
}

Widget ChatDisplay(BuildContext context, String name, String subject, List members) {
  return Center(
    child: Container(

      decoration: BoxDecoration(
            color: chatBlue,
            borderRadius: BorderRadius.circular(25),
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5, // changes position of shadow
              )
            ],
      ),
      child: SizedBox(
        width: 330,
        height: 190,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: titleStyle(24),),
              SizedBox(
                height: verticalSpacing,
              ),
              Text("Subject: " + subject, style: titleStyle(18),),
              SizedBox(
                height: verticalSpacing,
              ),
              Text("Members: " + members.toString(), style: titleStyle(18),)

            ],
          ),
        )

        ),
    ),
  );
}

