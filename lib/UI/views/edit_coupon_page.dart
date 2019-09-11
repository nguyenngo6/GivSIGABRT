import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:giver_app/UI/views/merchant_home_view.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';

class EditCoupon extends StatefulWidget {
  EditCoupon({
    @required this.user,
    @required this.coupon,
  });
  final User user;
  final Coupon coupon;
  // final usedBy;
  // final index;
  @override
  _EditCouponState createState() => _EditCouponState();
}

class _EditCouponState extends State<EditCoupon> {
  String description;
  int points;
  bool isUsed = false;
  String ownedBy;
  String code;
//  String usedBy;

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  void onChanged(bool value) {
    setState(() {
      isUsed = value;
    });
  }

  _editCoupon() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      Firestore.instance
          .collection("coupons")
          .document(widget.coupon.id)
          .updateData({
        'description': description,
        'points': points,
        'isUsed': isUsed,
        'code': code,
      }).then(_navigateToMerchantHomeView());
    }
  }

  _navigateToMerchantHomeView() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MerchantHomeView(
              user: widget.user,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _navigateToMerchantHomeView),
        title: Center(
          child: Text('Edit Coupon'),
        ),
      ),
      body: SingleChildScrollView(
        child: Material(
            child: Form(
              key: _key,
              autovalidate: _validate,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: widget.coupon.code,
                      onSaved: (input) => code = input,
                      decoration: new InputDecoration(
                          icon: Icon(Icons.title),
                          hintText: "Coupon Name"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: widget.coupon.description,
                      onSaved: (input) => description = input,
                      decoration: new InputDecoration(
                          icon: Icon(Icons.dashboard),
                          hintText: "Coupon Description"),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: widget.coupon.points.toString(),
                      onSaved: (input) => points = int.parse(input),
                      decoration: InputDecoration(
                        icon: Icon(Icons.control_point),
//                 hintText: "${widget.user.points}",
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _editCoupon,
                        child: Text('Update'),
                      ),
                      RaisedButton(
                        onPressed: _navigateToMerchantHomeView,
                        child: Text('Cancel'),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}