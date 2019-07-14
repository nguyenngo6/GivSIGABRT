import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/Views/add_coupon_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giver_app/UI/views/edit_coupon_page.dart';



class CouponList extends StatefulWidget {
  CouponList({Key key, @required this.user,}): super(key: key);
  final FirebaseUser user;

  @override
  _CouponListState createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
              stream: Firestore.instance.collection("coupons").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot <QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                return new CouponListView(
//                    user: widget.user,
                  document: snapshot.data.documents,
                );
              },
            ),
          )
        ],
      ),

    );
  }
}
