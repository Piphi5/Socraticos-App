import 'dart:convert';

import 'package:Socraticos/backend/session.dart';
import 'package:Socraticos/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import  'package:flutter_socket_io/flutter_socket_io.dart';

class AnnouncementPage extends StatelessWidget {
  AnnouncementPage(this.nickname);

  final String nickname;

  var channel = new IOWebSocketChannel.connect(
      "wss://socraticos.herokuapp.com/chat/join",
      headers: Session.header
      );
  var socket = IO.io("wss://socraticos.herokuapp.com/chat/join", <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
    'extraHeaders': Session.header // optional
  });
  SocketIO socketIO = SocketIOManager().createSocketIO("wss://socraticos.herokuapp.com/chat/join", "join");
  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {

    socket.on('connect', (_) {
      print('connect');
      socket.emit("join",
          {
            "USERID" : "sRenAdDsmRNuPshMz8WAB2AjNsM2" ,
            "GROUPID" : "10b9d425-4e09-4dae-a414-84d6cdd22863",
          } );
      socket.on('msg', (data) => {print(data)});
    });





//    channel.sink.add(jsonEncode(
//        {
//          "userID" : "sRenAdDsmRNuPshMz8WAB2AjNsM2" ,
//          "groupID" : "10b9d425-4e09-4dae-a414-84d6cdd22863",
//        }));
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcement Page"),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  return snapshot.hasData ?
                  Text(
                      snapshot.data.toString(),
                      style: Theme.of(context).textTheme.display1
                  )
                      :
                  CircularProgressIndicator();
                },
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    labelText: "Enter your message here"
                ),
              )
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: () {
            print("send msg");
            socket.send([controller.text]);
          }
      ),
    );
  }
}