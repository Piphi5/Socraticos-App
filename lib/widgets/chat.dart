//import 'package:flutter/material.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';
//
//class AnnouncementPage extends StatelessWidget {
//  AnnouncementPage(this.nickname);
//
//  final String nickname;
//
//  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(URL));
//  final TextEditingController controller = TextEditingController();
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Announcement Page"),
//      ),
//      body: Center(
//          child: Column(
//            children: <Widget>[
//              StreamBuilder(
//                stream: channel.stream,
//                builder: (context, snapshot) {
//                  return snapshot.hasData ?
//                  Text(
//                      snapshot.data.toString(),
//                      style: Theme.of(context).textTheme.display1
//                  )
//                      :
//                  CircularProgressIndicator();
//                },
//              ),
//              TextField(
//                controller: controller,
//                decoration: InputDecoration(
//                    labelText: "Enter your message here"
//                ),
//              )
//            ],
//          )
//      ),
//      floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.send),
//          onPressed: () {
//            channel.sink.add("$nickname: ${controller.text}");
//          }
//      ),
//    );
//  }
//}