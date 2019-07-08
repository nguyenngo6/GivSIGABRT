import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/customer_home_page.dart';
import 'package:giver_app/UI/merchant_home_page.dart';
import 'package:giver_app/UI/sign_in_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.user, this.firebaseAuth})
      : super(key: key);
  final FirebaseUser user;
  final FirebaseAuth firebaseAuth;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(widget.user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData) {
            print("this is level:");
            print(snapshot.data.data['level']);
            switch (snapshot.data.data['level']) {
              case 1:
                return CustomerHomePage(user: widget.user);
              case 2:
                return MerchantHomePage(user: widget.user);
            }
          }
        },
      ),
      floatingActionButton: new RaisedButton(
        onPressed: signOut,
        child: Text('Sign Out'),
      ),
    );
  }

  Future<void> signOut() {
    Future.wait([
      widget.firebaseAuth.signOut(),
    ]);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
