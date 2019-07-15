import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/views/merchant_home_view.dart';
import 'package:giver_app/model/user.dart';

class AddCoupon extends StatefulWidget {
  AddCoupon({
    @required this.user,
  });
  final User user;
  @override
  _AddCouponsState createState() => _AddCouponsState();
}

class _AddCouponsState extends State<AddCoupon> {
  String description;
  int point;
//  bool isUse;

  void _addData(User user) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference addDataCoupon =
          await Firestore.instance.collection("coupons").add({
//        "user": widget.user,
        "description": description,
        "point": point,
        "ownedBy": user.id,
        "isUsed": false,
//        "isUse": isUse,
      });
      print(addDataCoupon.documentID.toString());
      CollectionReference addUidMerchant = Firestore.instance
          .collection("users")
          .document(user.id)
          .collection("ownedCoupons");
      await addUidMerchant.document(addDataCoupon.documentID).setData({
        "merchantId":
            Firestore.instance.collection("users").document(user.id).documentID
      });
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => new MerchantHomeView(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Material(
          child: Form(
        child: Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (String str) {
                  setState(() {
                    description = str;
                  });
                },
                decoration: new InputDecoration(
                    icon: Icon(Icons.dashboard),
                    hintText: "Coupon Description"),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onSaved: (input) => point = int.parse(input),
                decoration: new InputDecoration(
                  icon: Icon(Icons.control_point),
                  hintText: "Enter number credit",
                ),
                keyboardType: TextInputType.number,
              ),
            ),

            // new Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child:TextField(
            //     onChanged: (String str){
            //       setState(() {
            //         ownedBy = str;
            //       });
            //     },
            //     decoration: InputDecoration(
            //         icon: Icon(Icons.account_circle),
            //         hintText: "Owned by"
            //     ),
            //   ),
            // ),

            // new Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: TextField(
            //     onChanged: (String str){
            //       setState(() {
            //         usedBy = str;
            //       });
            //     },
            //     decoration: InputDecoration(
            //         icon: Icon(Icons.account_circle),
            //         hintText: "Used by"
            //     ),
            //   ),

            // ),

            new Padding(
              padding: const EdgeInsets.all(20.0),
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _addData(widget.user);
                },
              ),
            ),

//          new Padding(
//              padding: const EdgeInsets.all(16.0),
//            child: ,
//          )
          ],
        ),
      )),
    );
  }
}
