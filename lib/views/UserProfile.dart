import 'package:Socraticos/widgets/navbar.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:flutter/material.dart';

final Color profileBlue = const Color(0xffB5F8FF);
final double verticalSpacing = 20;

class UserProfile extends StatelessWidget {
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
  final double containerSpacing = 30;
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
                Text(
                  "Name",
                  style: titleStyle(36),
                ),

              ],
            )),
        Positioned(
          left: 50,
          top: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: containerSpacing,
              ),
              Text(
                "Email: ",
                style: titleStyle(18),
              ),
              SizedBox(
                height: containerSpacing,
              ),
              Text(
                "Description: ",
                style: titleStyle(18),
              )
            ],
          ),
        )
      ],
    ),
  );
}
