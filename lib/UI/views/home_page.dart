import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:giver_app/UI/views/merchant_home_view.dart';

import 'customer_home_view.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.user})
      : super(key: key);
  final FirebaseUser user;

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
                return CustomerHomeView(user: widget.user);
              case 2:
                return MerchantHomeView(user: widget.user);
            }
          }
        },
      ),
    );
  }
}
