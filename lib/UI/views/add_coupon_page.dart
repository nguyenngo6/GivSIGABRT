import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/views/merchant_home_page.dart';


class AddCoupon extends StatefulWidget {

  AddCoupon({Key key, @required this.user,}): super(key: key);
  final FirebaseUser user;
  @override
  _AddCouponsState createState() => _AddCouponsState();
}

class _AddCouponsState extends State<AddCoupon> {

  String description;
  int point;
//  bool isUse;
  String ownedBy;
  String usedBy;

  void _addData() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference1 = await Firestore.instance.collection("coupons").add({
//        "user": widget.user,
        "description": description,
        "ownedBy": ownedBy,
        "point": point,
        "usedBy": usedBy,
//        "isUse": isUse,
      });
      CollectionReference reference2 = Firestore.instance.collection("users").document(widget.user.uid).collection("ownedCoupons");
      await reference2.document(reference1.documentID).setData({"merchantId": Firestore.instance.collection("users").document(widget.user.uid)});
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new MerchantHomePage(user: widget.user)));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  description = str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.dashboard),
                  hintText: "Coupon Description"
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String number){
                setState(() {
                  point = number as int;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.control_point),
                hintText: "Enter number credit",
              ),
              keyboardType: TextInputType.number,
            ),
          ),

          new Padding(
            padding: const EdgeInsets.all(16.0),
            child:TextField(
              onChanged: (String str){
                setState(() {
                  ownedBy = str;
                });
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  hintText: "Owned by"
              ),
            ),
          ),

          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  usedBy = str;
                });
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  hintText: "Used by"
              ),
            ),

          ),

          new Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: (){
                _addData();

              },
            ),

          ),

//          new Padding(
//              padding: const EdgeInsets.all(16.0),
//            child: ,
//          )
        ],
      ),
    );
  }
}