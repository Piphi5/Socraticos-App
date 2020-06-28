import 'dart:async';
import 'dart:convert';

import 'package:Socraticos/backend/session.dart';
import 'package:Socraticos/views/chats.dart';
import 'package:Socraticos/views/pinnedChats.dart';
import 'package:Socraticos/widgets/navbar.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;


class ChatPage extends StatefulWidget {
  String groupID;
  String _title;
  List<String> messages;
  ChatPage(this.groupID, this._title);
  @override
  _ChatPageState createState() => _ChatPageState(groupID, _title);
}

class _ChatPageState extends State<ChatPage> {
  String groupID;
  String _title;
  List<Message> messages;
  bool histLoaded = false;
  bool socketConnect = false;
  _ChatPageState(this.groupID, this._title);

  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  IO.Socket socket;

  @override
  void initState() {

    //Initializing the message list
    fetchTexts().then((value) =>
        setState(() {
          histLoaded = value;
        }));

    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();
    scrollController = ScrollController(initialScrollOffset: 50);
    //Creating the socket
    socket = IO.io("wss://socraticos.herokuapp.com/", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': Session.header
    });

    socket.on('connect', (_) {
      print('connect');
      print(groupID);
      socket.emit("join",
          {
            "USERID" : appUser.id,
            "GROUPID" : groupID,
          });
      setState(() {
        socketConnect = true;
      });
    });

    socket.on("newMessage", (jsonText) {
      print("GOT MESSAGE");
      Message data = Message.fromJson(jsonText);
      //print(data["content"]);




      this.setState(() {
        messages.insert(0, data);


      } );

      //print(data);



    });
    super.initState();
    print("DONE BUILDING");


  }

  Future<bool> fetchTexts() async {
    print("fetchign texts");
    messages = [];
    final response = await Session.getNoContent(
        "https://socraticos.herokuapp.com/groups/chatHistory/$groupID?maxResults=120"
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

  Widget buildChatInput() {
    return Container(
      width: width * 0.7,
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.only(left: 40.0),
      child: TextField(
        decoration: InputDecoration.collapsed(
          hintText: 'Send a message...',
        ),
        controller: textController,
      ),
    );
  }

  Widget buildSendButton() {
    return FloatingActionButton(
      backgroundColor: chatBlue,
      onPressed: () {
        //Check if the textfield has text or not
        if (textController.text.isNotEmpty) {
          //Send the message as JSON data to send_message event
          socket.emit("newMessage", textController.text);
          print("send msg");
          textController.text = '';
          //Scrolldown the list to show the latest message
//          scrollController.animateTo(
//            scrollController.position.maxScrollExtent,
//            duration: Duration(milliseconds: 600),
//            curve: Curves.ease,
//          );
        }
      },
      child: Icon(
        Icons.send,
        size: 30,
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      height: height * 0.1,
      width: width,
      child: Row(
        children: <Widget>[
          buildChatInput(),
          buildSendButton(),
        ],
      ),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    PinnedChatHistory(groupID, _title))
            );
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
            buildInputArea(),
          ],
        ),
      ),
    ) : CircularProgressIndicator();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    socket.disconnect();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socket.destroy();
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
      "unpin" : !isPinned
    };
    Session.post("https://socraticos.herokuapp.com/groups/setPin/$groupID/$messageID", data);

  }

}
