import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/views/customer_home_page.dart';

import 'package:giver_app/UI/views/sign_in_page.dart';

class BlockHomePage extends StatefulWidget {
  const BlockHomePage ({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _BlockHomePageState createState() => _BlockHomePageState();
}

class _BlockHomePageState extends State<BlockHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("You have to verify your account"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: signIn,
                  child: Text('Sign In'),
                ),
                Container(width: 50.0,),
                RaisedButton(
                  onPressed: () {
                    print("send email to-->");
                    print(widget.user.email);
                    widget.user.sendEmailVerification();
                    signIn();
                  },
                  child: Text("Don't receive? Send Again"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
