import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giver_app/UI/merchant_home_page.dart';
import 'package:giver_app/UI/add_coupon_page.dart';

class EditCoupon extends StatefulWidget {
  EditCoupon({Key key, @required  this.description, this.ownedBy, this.usedBy, this.point, this.user, this.index}) : super(key: key);
  final FirebaseUser user;
  final description;
  final ownedBy;
  final usedBy;
  final point;
  final index;
  @override
  _EditCouponState createState() => _EditCouponState();
}

class _EditCouponState extends State<EditCoupon> {

  String description;
  String point;

//  bool isUse;
  String ownedBy;
  String usedBy;
  TextEditingController controllerDes;
  TextEditingController controllerOwned;
  TextEditingController controllerPoint;
  TextEditingController controllerUsed;

  Future _editCoupon() async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot =
      await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "description": description,
        "ownedBy": ownedBy,
        "point": point,
        "usedBy": usedBy,
      });
    });

    Navigator.pop(context);
//    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new kfc_store(user: widget.user))) ;
  }

  @override
  void initState() {
    super.initState();
    description = widget.description;
    ownedBy = widget.ownedBy;
    point = widget.point;
    usedBy = widget.usedBy;

    controllerDes = new TextEditingController(text: widget.description);
    controllerOwned = new TextEditingController(text: widget.ownedBy);
    controllerPoint = new TextEditingController(text: widget.point);
    controllerUsed = new TextEditingController(text: widget.usedBy);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                  icon: Icon(Icons.dashboard),
                  hintText: "Coupon Description"
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controllerPoint,
              onChanged: (String number) {
                setState(() {
                  point = number;
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
            child: TextField(
              controller: controllerOwned,
              onChanged: (String str) {
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
              controller: controllerUsed,
              onChanged: (String str) {
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
              onPressed: () {
                _editCoupon();
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
class CouponList extends StatelessWidget {
  CouponList({Key key, @required this.document}) : super(key: key);
//  final FirebaseUser user;

  List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: document.length,
        itemBuilder: (BuildContext context, int i) {
          String title = document[i].data['description'].toString();
          String ownedBy = document[i].data['ownedBy'].toString();
          String point = document[i].data['point'].toString();
          String usedBy = document[i].data['usedBy'].toString();

          return new Dismissible(
              key: new Key(document[i].documentID),
              onDismissed: (direction) {
                Firestore.instance.runTransaction((transaction) async {
                  DocumentSnapshot snapshot =
                  await transaction.get(document[i].reference);
                  await transaction.delete(snapshot.reference);
                });
              },

              child: new Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 5.0, bottom: 5.0),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Text(title, style: new TextStyle(fontSize: 20.0),)
                        ],
                      ),
                      new IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new EditCoupon(
//                              user: user,
//                              user: user,
                                  description: title,
                                  ownedBy: ownedBy,
                                  point: point,
                                  usedBy: usedBy,
                                  index: document[i].reference,
                                )));
                          }
                      )
                    ],
                  ),
                ),
              )
          );
        });
  }
}