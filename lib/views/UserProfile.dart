import 'package:Socraticos/widgets/navbar.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final Color profileBlue = const Color(0xffB5F8FF);
final double verticalSpacing = 20;

final String testId = "4f51f5a7-cf33-41d0-b1c3-1d958e378cdf";

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}
class _UserProfileState extends State<UserProfile> {
  Future<User> futureUser;
  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing),
              child: Text("My Profile", style: titleStyle(48))),
          SizedBox(
            height: verticalSpacing,
          ),
          profileDisplay(context),
        ],

    );
  }
}

//class UserProfile extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Container(
//              padding: EdgeInsets.symmetric(vertical: verticalSpacing),
//              child: Text("My Profile", style: titleStyle(48))),
//          SizedBox(
//            height: verticalSpacing,
//          ),
//          profileDisplay(context),
//        ],
//
//    );
//  }
//}

Widget profileBox(BuildContext context) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        color: profileBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ));
}

Widget profileDisplay(BuildContext context) {
  final double width = MediaQuery.of(context).size.width*0.8;
  final double containerSpacing = 30;
  return FutureBuilder<User>(
    future: fetchUser(),
    builder: (context, snapshot) {
      print(snapshot.hasData);
      if (snapshot.hasData) {
        return Expanded(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              profileBox(context),
              Positioned(
                  top: containerSpacing,
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 25, // changes position of shadow
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: containerSpacing,
                      ),


                    ],
                  )),
              Positioned(
                left: 50,
                top: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      child: Center(
                        child: Text(
                          snapshot.data.name,
                          style: titleStyle(36),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: containerSpacing,
                    ),
                    Text(
                      "Email: " + snapshot.data.email,
                      style: titleStyle(18),
                    ),
                    SizedBox(
                      height: containerSpacing,
                    ),
                    Container(
                      width: width,
                      child: Text(
                        "Description: " + snapshot.data.description,
                        style: titleStyle(18),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

class User {
  final String name;
  final String email;
  final String description;

  User({this.name, this.email, this.description});
  factory User.fromJson(Map<String, dynamic> json) {

    return User(name: json["name"], email: json["email"],description: json["desc"]);
  }

}

Future<User> fetchUser() async {
  final response = await http.get("https://socraticos.herokuapp.com/users/4f51f5a7-cf33-41d0-b1c3-1d958e378cdf");
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}