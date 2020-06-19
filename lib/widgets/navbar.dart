import 'package:Socraticos/views/UserProfile.dart';
import 'package:Socraticos/views/chats.dart';
import 'package:Socraticos/views/search.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class NavigationBar extends StatefulWidget {
  NavigationBar({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<NavigationBar> {
  _NavigationState();
  int _selectedIndex = 0;
  Future<User> user;
  static List<Widget> _widgetOptions = <Widget>[
    Search(),
    ChatsList(),
    UserProfile(),
    Loading()

  ];
  Widget currWidget = _widgetOptions.elementAt(0);


  @override
  void initState() {
    super.initState();
    user = fetchUser();
  }



  void _onItemTapped(int index) {


    setState(() {
      _selectedIndex = index;
      currWidget = _widgetOptions.elementAt(index);
      print(user);

    });
  }

  @override
  Widget build(BuildContext context) {


    return
      Scaffold(
        backgroundColor: background,
        appBar: appBarMain(context),
        body:currWidget,
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appBarBlue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              title: Text('Socraticos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text('Profile'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),

      );
  }
}

class User {
  final String name;
  final String email;
  final String description;
  final List chats;

  User({this.name, this.email, this.description, this.chats});
  factory User.fromJson(Map<String, dynamic> json) {

    return User(name: json["name"], email: json["email"],description: json["desc"], chats: [json["enrollments"], json["mentorships"]].expand((x) => x).toList());
  }

}
Widget Loading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
Future<User> fetchUser() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  print("https://socraticos.herokuapp.com/users/" + user.uid);
  final response = await http.get("https://socraticos.herokuapp.com/users/" + user.uid);
//  final response = await http.get("https://socraticos.herokuapp.com/users/" + "LODLn1hE2BTKCp7SGk3d7lqiOih2");
//    print("https://socraticos.herokuapp.com/users/" + "LODLn1hE2BTKCp7SGk3d7lqiOih2");

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    User userInstance = User.fromJson(json.decode(response.body));
    return userInstance;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load user');
  }
}
