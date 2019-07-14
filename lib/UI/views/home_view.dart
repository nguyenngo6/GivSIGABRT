import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:giver_app/UI/views/merchant_home_view.dart';
import 'package:giver_app/scoped_model/home_view_model.dart';


import 'base_view.dart';
import 'customer_home_view.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key key, @required this.user})
      : super(key: key);
  final FirebaseUser user;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
        builder: (context, child, model) => Scaffold(
          body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('users')
                .document(model.getCurrentUser(model.users, widget.user.uid).id)
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
                    return CustomerHomeView(user: model.getCurrentUser(model.users, widget.user.uid));
                  case 2:
                    return MerchantHomeView(user: model.getCurrentUser(model.users, widget.user.uid));
                }
              }
            },
          ),
        ));
  }
}
