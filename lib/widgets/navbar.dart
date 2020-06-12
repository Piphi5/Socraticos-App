import 'package:Socraticos/views/UserProfile.dart';
import 'package:Socraticos/views/chats.dart';
import 'package:Socraticos/views/search.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:flutter/material.dart';



class NavigationBar extends StatefulWidget {
  NavigationBar({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<NavigationBar> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Search(),
    ChatsList(),
    UserProfile(),

  ];
  Widget currWidget = _widgetOptions.elementAt(0);



  void _onItemTapped(int index) {


    setState(() {
      _selectedIndex = index;
      currWidget = _widgetOptions.elementAt(index);

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
