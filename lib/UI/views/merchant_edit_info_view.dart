import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/views/merchant_home_view.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';
import 'package:giver_app/service_locator.dart';

class MerchantUpdateInfoView extends StatefulWidget {
  const MerchantUpdateInfoView({@required this.merchant});

  final User merchant;

  @override
  _MerchantUpdateInfoViewState createState() => _MerchantUpdateInfoViewState();
}

class _MerchantUpdateInfoViewState extends State<MerchantUpdateInfoView> {

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String _username, _address, _phone;

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: FlatButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MerchantHomeView(user: widget.merchant,))),
          child: Icon(Icons.arrow_back),
        ),
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
    if(_key.currentState.validate()){
      _key.currentState.save();
      Firestore.instance
        .collection("users")
        .document(widget.merchant.id)
        .updateData({
          'username' : _username,
          'phone' : _phone,
          'address' : _address,
        }).then(_navigateToMerchantHomeView());
    } else {
      _navigateToMerchantHomeView();
    }

  }
  _navigateToMerchantHomeView(){
    UserHomeViewModel model = locator<UserHomeViewModel>();
    User updatedUser = model.getCurrentUser(model.merchants, widget.merchant.id);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MerchantHomeView(user: updatedUser,)));
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
            _username = val;
          },
        ),
        new TextFormField(
            initialValue: widget.merchant.phone,
            decoration: new InputDecoration(hintText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: validate,
            onSaved: (String val) {
              _phone = val;
            }),
        new TextFormField(
            initialValue: widget.merchant.address,
            decoration: new InputDecoration(hintText: 'Address'),
            maxLength: 32,
            validator: validate,
            onSaved: (String val) {
              _address = val;
            }),
        new SizedBox(height: 15.0),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _updateMerchantData,
              child: new Text('Update'),
            ),
            Container(
              width: 20,
            ),
            RaisedButton(
              onPressed: _navigateToMerchantHomeView,
              child: new Text('Cancel'),
            )
          ],
        )
      ],
    );
  }
}