import 'package:Socraticos/widgets/navbar.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final Color chatBlue = const Color(0xff71C9CE);
final double verticalSpacing = 20;

List<String> membersTest = ["Breh", "Pooj", "Nation", "APCS", "Yuh", "Clean"];

class ChatsList extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<ChatsList> {
  Future<Chat> chatList;

  @override
  Widget build(BuildContext context) {
    final topBar = SliverAppBar(
      pinned: false,
      expandedHeight: 195,
      backgroundColor: Color(0xffCBF1F5),
      flexibleSpace: Container(
        alignment: Alignment.centerLeft,
        child: FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(10),
            title: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "My\nSocraticos",
                  style: titleStyle(48),
                ))),
      ),
    );
    return FutureBuilder<List<Chat>>(
      future: fetchChats(),
      builder: (context, snapshot) {
        Widget chatListSliver;
        if (snapshot.hasError) print(snapshot.error);
        if (snapshot.hasData) {
          chatListSliver = SliverFixedExtentList(
              itemExtent: 200,
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return snapshot.data[index].displayChat(context);
              }, childCount: snapshot.data.length));
        } else {
          chatListSliver = SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(100),
            child: Center(
                child: CircularProgressIndicator(
              backgroundColor: chatBlue,
            )),
          ));
        }

        return CustomScrollView(
          slivers: <Widget>[topBar, SliverPadding(padding: EdgeInsets.all(5.0),sliver: chatListSliver)],
        );
      },
    );
  }
}

Widget chatDisplay(
    BuildContext context, String name, String subject, List members) {
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
                Text(
                  name,
                  style: titleStyle(24),
                ),
                SizedBox(
                  height: verticalSpacing,
                ),
                Text(
                  "Subject: " + subject,
                  style: titleStyle(18),
                ),
                SizedBox(
                  height: verticalSpacing,
                ),
                Text(
                  "Members: " + members.toString(),
                  style: titleStyle(18),
                )
              ],
            ),
          )),
    ),
  );
}

class Chat {
  final String title;
  final List students;
  final String description;
  final String groupId;

  Chat({this.title, this.students, this.description, this.groupId});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        title: json["title"] as String,
        students: json["students"] as List,
        description: json["description"] as String,
        groupId: json["groupID"] as String);
  }
  Widget displayChat(context) {
    return chatDisplay(context, this.title, this.description, this.students);
  }
}

Future<List<Chat>> fetchChats() async {
  final url = "https://socraticos.herokuapp.com/groups/list";
  final response = await http.Client()
      .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    final list = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return list.map<Chat>((json) => Chat.fromJson(json)).toList();
  }
}
