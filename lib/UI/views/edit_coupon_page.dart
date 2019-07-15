import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:giver_app/model/coupon.dart';

class EditCoupon extends StatefulWidget {
  EditCoupon({@required this.description, @required this.ownedBy});
  final description;
  final ownedBy;
  // final usedBy;
  // final point;
  // final index;
  @override
  _EditCouponState createState() => _EditCouponState();
}

class _EditCouponState extends State<EditCoupon> {
  String description;
  int point;

//  bool isUse;
  String ownedBy;
  String usedBy;
  TextEditingController controllerDes;
  TextEditingController controllerOwned;

//   Future _editCoupon() async {
//     Firestore.instance.runTransaction((Transaction transaction) async {
//       DocumentSnapshot snapshot = await transaction.get(widget.index);
//       await transaction.update(snapshot.reference, {
//         "description": description,
//         "ownedBy": ownedBy,
//       });
//     });

//     Navigator.pop(context);
// //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new kfc_store(user: widget.user))) ;
//   }

  @override
  void initState() {
    super.initState();
    description = widget.description;
    ownedBy = widget.ownedBy;

    controllerDes = new TextEditingController(text: widget.description);
    controllerOwned = new TextEditingController(text: widget.ownedBy);
  }

  bool isNumber(String value) {
    if (value == null) {
      return true;
    }
    final n = num.tryParse(value);
    return n != null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Form(
      child: Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controllerDes,
              onChanged: (String str) {
                setState(() {
                  description = str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.dashboard), hintText: "Coupon Description"),
            ),
          ),
          // new Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: TextFormField(
          //     controller: controllerPoint,
          //     onSaved: (input) => point = int.parse(input),
          //     decoration: new InputDecoration(
          //       icon: Icon(Icons.control_point),
          //       hintText: "Enter number credit",
          //     ),
          //     keyboardType: TextInputType.number,
          //     inputFormatters: <TextInputFormatter>[
          //       WhitelistingTextInputFormatter.digitsOnly
          //     ],
          //   ),
          // ),

          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controllerOwned,
              onChanged: (String str) {
                setState(() {
                  ownedBy = str;
                });
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.account_circle), hintText: "Owned by"),
            ),
          ),

          new Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: null,
            ),
          ),

//          new Padding(
//              padding: const EdgeInsets.all(16.0),
//            child: ,
//          )
        ],
      ),
    ));
  }
}

class CouponListView extends StatelessWidget {
  CouponListView({@required this.couponList});
//  final FirebaseUser user;

  final List<Coupon> couponList;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: couponList.length,
        itemBuilder: (BuildContext context, rowNumber) {
          Coupon coupon = couponList[rowNumber];
          return new Container(
            child: Dismissible(
              key: new Key(coupon.id),
              onDismissed: (direction) {
                Firestore.instance.runTransaction((transaction) async {
                  DocumentSnapshot snapshot = await transaction.get(Firestore
                      .instance
                      .collection('coupons')
                      .document(coupon.id));
                  await transaction.delete(snapshot.reference);
                });
              },
              child: new Container(
                margin: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Material(
                    color: Colors.lightBlueAccent,
                    shadowColor: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                            child: new Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      coupon.description,
                                      style: new TextStyle(fontSize: 5.0),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                        Container(
                          width: 25,
                          height: 25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image(
                                fit: BoxFit.contain,
                                alignment: Alignment.topRight,
                                image: AssetImage('assets/profile.png')),
                          ),
                        ),
                        Container(
                          child: new IconButton(
                              iconSize: 10.0,
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new EditCoupon(
//                              user: user,
//                              user: user,
                                              description: coupon.description,
                                              ownedBy: coupon.ownedBy,
                                            )));
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
