import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giver_app/UI/views/customer_home_view.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';

import 'base_view.dart';

class RedCrossView extends StatefulWidget {
  final User user;
  RedCrossView({@required this.user});
  @override
  _RedCrossViewState createState() => _RedCrossViewState();
}

class _RedCrossViewState extends State<RedCrossView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<UserHomeViewModel>(
        builder: (context, child, model) => Scaffold(
          appBar: AppBar(leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomerHomeView(user: widget.user)));
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          })),
          body: null,
        ));
  }
}


