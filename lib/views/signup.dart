import 'package:Socraticos/views/signin.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password, _name, _description;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: background,
      appBar: appBarMain(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (input) {
                      if(input.isEmpty){
                        return 'Provide a name';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
                      hintStyle: TextStyle(color: Colors.black)

                    ),
                    style: TextStyle(color: Colors.black),

                    cursorColor: Colors.black,
                    onSaved: (input) => _name = input,
                  ),
                  TextFormField(
                    validator: (input) {
                      if(input.isEmpty){
                        return 'Provide a description';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Description'
                    ),
                    onSaved: (input) => _description = input,
                  ),
                  TextFormField(
                    validator: (input) {
                      if(input.isEmpty){
                        return 'Provide an email';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Email'
                    ),
                    onSaved: (input) => _email = input,
                  ),
                  TextFormField(
                    validator: (input) {
                      if(input.length < 6){
                        return 'Longer password please';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Password'
                    ),
                    onSaved: (input) => _password = input,
                    obscureText: true,
                  ),
                  RaisedButton(
                    onPressed: signUp,
                    child: Text('Sign up'),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> getUserMap(String userID) {
    return {
      "name" : _name,
      "email" : _email,
      "desc" : _description,
      "userID" : userID,
      "mentorships" : [],
      "enrollments" : [],
      "tags" : _name.split(" ")
    };

  }
  void uploadUser(String userId) async {
    await Firestore.instance.collection("/users").document(userId).setData(getUserMap(userId));

  }
  void signUp() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).then((value) => {
          print(value.user.uid.toString()),
          uploadUser(value.user.uid.toString())

        }

        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        //databaseMethods.uploadUserInfo(userInfoMap);


      }catch(e){
        print(e.message);
      }
    }
  }
}