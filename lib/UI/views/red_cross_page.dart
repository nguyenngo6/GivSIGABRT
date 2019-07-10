import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giver_app/UI/customer_home_page.dart';

class RedCross extends StatefulWidget {
  const RedCross ({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;
  static String tag = "red_cross";

  @override
  RedCrossState createState() {
    // TODO: implement createState
    return RedCrossState();
  }


}
class RedCrossState extends State<RedCross>{
  @override
  Widget build(BuildContext context) {
    final icon = Hero(
      tag: 'Icon',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/redcross.png'),
        ),
      ),
    );
    final wellcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Red Cross',
        style: TextStyle(fontSize: 28.0, color: Colors.black87),
      ),
    );
    final detail = RichText(
      text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Our Work\n',
              style: TextStyle(fontSize: 19.0, color: Colors.black),
            ),
            TextSpan(
              text: 'Red Cross volunteers and staff work to deliver vital services – from providing relief and support to those in crisis, to helping you be prepared to respond in emergencies.\n\n',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            TextSpan(
              text: 'Who We Are\n',
              style: TextStyle(fontSize: 19.0, color: Colors.black,),
            ),
            TextSpan(
              text: 'From the mission, fundamental principles and business practices that guide our organization, to the history of our service for more than a century, get to know the Red Cross.\n\n',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            TextSpan(
              text: 'You Can Make a Difference\n',
              style: TextStyle(fontSize: 19.0, color: Colors.black),
            ),
            TextSpan(
              text: 'Your financial gift helps people affected by disasters big and small',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
          ]
      ),
    );
//    final detail = Padding(
//      padding: EdgeInsets.all(8.0),
//      child: Text(
//          'Our Work \n'
//          'Red Cross volunteers and staff work to deliver vital services – from providing relief and support to those in crisis, to helping you be prepared to respond in emergencies.\n'
//          'Who We Are\n'
//          'From the mission, fundamental principles and business practices that guide our organization, to the history of our service for more than a century, get to know the Red Cross.\n'
//          'You Can Make a Difference\n'
//          'Your financial gift helps people affected by disasters big and small\n',
//          style: TextStyle(fontSize: 16.0, color: Colors.black),
//          textAlign: TextAlign.center,
//      ),
//    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
          gradient:
          LinearGradient(colors: [Colors.white,Colors.white])),
      child: Column(
        children: <Widget>[icon, wellcome, detail],
      ),
    );
    return Scaffold(
      appBar: AppBar(leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomerHomePage(user: widget.user,)));
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      })),
      body: body,
    );
  }


}