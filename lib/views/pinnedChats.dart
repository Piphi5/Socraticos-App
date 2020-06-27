import 'dart:async';
import 'dart:convert';

import 'package:Socraticos/backend/session.dart';
import 'package:Socraticos/views/chats.dart';
import 'package:Socraticos/widgets/navbar.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;


class PinnedChatHistory extends StatefulWidget {
  String groupID;
  String _title;
  List<String> messages;
  PinnedChatHistory(this.groupID, this._title);
  @override
  _PinnedChatPageState createState() => _PinnedChatPageState(groupID, _title);
}

class _PinnedChatPageState extends State<PinnedChatHistory> {
  String groupID;
  String _title;
  List<Message> messages;
  bool histLoaded = false;
  bool socketConnect = false;
  _PinnedChatPageState(this.groupID, this._title);

  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  IO.Socket socket;

  @override
  void initState() {
    super.initState();
    print("DONE BUILDING");
    fetchTexts();
  }

  Future<bool> fetchTexts() async {
    print("fetchign texts");
    messages = [];
    final response = await Session.getNoContent(
        "https://socraticos.herokuapp.com/groups/pinnedHistory/$groupID?maxResults=120"
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      for (Map<String, dynamic> obj in data) {
        messages.add(Message.fromJson(obj));
      }
      return true;
    }
    return false;
  }


  Widget buildSingleMessage(int index) {

    return Container(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20),
          decoration: BoxDecoration(
            color: chatBlue,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: (width - 40) * .75,
                  child: Text(
                    messages[index].content,
                  ),
                ),
                Icon(messages[index].isPinned ? (Icons.star) : (Icons.star_border),
                  size: 20,),




              ],
            ),
          ),
        ),
        onTap: () {
          setState(() {
            messages[index].updatePinned(groupID);
          });

        },
      ),
    );
  }

  Widget buildMessageList() {
    if(messages == null) {
      fetchTexts();
    }
    return Container(
        height: height * 0.8,
        width: width,
        child:
        ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          reverse: true,
          shrinkWrap: true,
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return buildSingleMessage(index);
          },
        )



    );


  }


  Widget chatAppBar(BuildContext context) {
    return AppBar(
      title: Text(_title),
      backgroundColor: appBarBlue,
      actions: [
        IconButton(
          icon: Icon(Icons.star_border),
          onPressed: () {
            // do something
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = chatAppBar(context);
    height = MediaQuery.of(context).size.height - appBar.preferredSize.height;
    width = MediaQuery.of(context).size.width;
    return histLoaded && socketConnect ? Scaffold(
      appBar: appBar,
      backgroundColor:  appBarBlue,
      body: SingleChildScrollView(

        child: Column(
          children: <Widget>[
            buildMessageList(),
          ],
        ),
      ),
    ) : CircularProgressIndicator();
  }

}

class Message {
  String username, content, messageID;
  bool isPinned;

  Message({this.username, this.content, this.isPinned, this.messageID});

  factory Message.fromJson(Map<String, dynamic> json) {
    var pinned = json["pinned"];
    if (pinned == null) {
      pinned = false;
    } else {
      pinned = !pinned;
    }
    return Message(
        username: json["authorID"],
        content: json["content"],
        isPinned: pinned,
        messageID: json["messageID"]
    );
  }

  void updatePinned(String groupID) {

    isPinned = !isPinned;
    Map<String, dynamic> data = {
      "unpin" : isPinned
    };
    Session.post("https://socraticos.herokuapp.com/groups/setPin/$groupID/$messageID", data);

  }

}


