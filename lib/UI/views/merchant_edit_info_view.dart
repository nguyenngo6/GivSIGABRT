import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/model/user.dart';

class MerchantUpdateInfoView extends StatefulWidget {
  const MerchantUpdateInfoView({@required this.merchant});

  final User merchant;

  @override
  _MerchantUpdateInfoViewState createState() => _MerchantUpdateInfoViewState();
}

class _MerchantUpdateInfoViewState extends State<MerchantUpdateInfoView> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String username, address, phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Merchant Infomation'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            key: _key,
            autovalidate: _validate,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  _updateMerchantData() {
    //   Firestore.instance.collection('users')
    //       .document(widget.merchantSnapshot.documentID)
    //       .updateData({
    //         'username' : username,
    //         'phone' : phone,
    //         'address' : address
    //       });
    // }
  }

  String validate(String value) {
    if (value.length == 0) {
      return "Input can not be empty";
    }
    return null;
  }

  Widget formUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          initialValue: widget.merchant.username,
          decoration: new InputDecoration(hintText: 'Username'),
          maxLength: 32,
          validator: validate,
          onSaved: (String val) {
            username = val;
          },
        ),
        new TextFormField(
            initialValue: widget.merchant.phone,
            decoration: new InputDecoration(hintText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: validate,
            onSaved: (String val) {
              phone = val;
            }),
        new TextFormField(
            initialValue: widget.merchant.username,
            decoration: new InputDecoration(hintText: 'Address'),
            maxLength: 32,
            validator: validate,
            onSaved: (String val) {
              address = val;
            }),
        new SizedBox(height: 15.0),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _updateMerchantData(),
              child: new Text('Update'),
            ),
            Container(
              width: 20,
            ),
            RaisedButton(
              onPressed: _updateMerchantData(),
              child: new Text('Cancel'),
            )
          ],
        )
      ],
    );
  }
}
