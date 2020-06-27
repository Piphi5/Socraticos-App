import 'package:Socraticos/backend/session.dart';
import 'package:Socraticos/widgets/navbar.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chats.dart';

final Color profileBlue = const Color(0xffB5F8FF);
final double verticalSpacing = 20;
TextEditingController _controller;
class Search extends StatefulWidget {


  @override
    _SearchState createState() => _SearchState();

}

class _SearchState extends State<Search> {
  @override
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
        child: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: GroupSearch());
          },
        ),
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



class GroupSearch extends SearchDelegate<Chat> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
        onPressed: () {
            query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
          onPressed: () {
        close(context, null);
          },
    );
  }

  Future<List<Chat>> fetchGroups(String query) async {
    final response = await http.get("https://socraticos.herokuapp.com/groups/search?query=" + query.toLowerCase());
    var value = jsonDecode(response.body);
    return value.map<Chat>((json) => Chat.fromJson(json)).toList();


  }
  void joinGroup(String groupId) async {

    Map<String, dynamic> data = {
    'role': "student",
    "userID" : appUser.id
    };

    http.Response response = await Session.post('https://socraticos.herokuapp.com/groups/join/$groupId', data);
    refreshUser();
    print(appUser.chats);

  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: fetchGroups(query),
            builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text('${snapshot.data[index].title}'),
                        subtitle: AutoSizeText('${snapshot.data[index].description} \n${snapshot.data[index].students}', maxLines: 2,),
                  isThreeLine: true,
                  onTap: () {
                      appUser.chats.contains(snapshot.data[index].groupId) ?   print("already in group") : joinGroup(snapshot.data[index].groupId); //  TODO maybe have it alert them that they are already in it
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
    },

    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

}


