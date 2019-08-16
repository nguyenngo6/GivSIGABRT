import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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
  String selectedImageUrl = '';
  final _pointController = TextEditingController();
  String description;
  int points;
  String code;
//  String imageUrl;
  int selectRadio;
//  bool isUse;

  String imageUrl1 =
      'https://www.kfc.com.au/sites/default/files/alohadata/images/products/zinger_box_web_mobile.jpg';
  String imageUrl2 =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBIWOP97VpX378KHyoggAd12JFRJdNcY8vDHRxtF3sNuUaCZvO';
  String imageUrl3 =
      'https://fishryimages.blob.core.windows.net/product/1555331915948-product.jpeg/xs';
//  @override
//  void innitState() {
//    super.initState();
//    selectRadio = 0;
//  }

  setSelectedRadio(int val) {
    setState(() {
      selectRadio = val;

    });
  }

  void _addData(User user) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference addDataCoupon =
          await Firestore.instance.collection("coupons").add({
//        "user": widget.user,
        "description": description,
        "points": int.parse(_pointController.text),
        "ownedBy": user.id,
        "code": code,
        "isUsed": false,
        "isPending": false,
        "usedBy": "",
        "imageUrl": selectedImageUrl
      });
//      print(addDataCoupon.documentID.toString());
      CollectionReference addUidMerchant = Firestore.instance
          .collection("users")
          .document(user.id)
          .collection("ownedCoupons");
      await addUidMerchant.document(addDataCoupon.documentID).setData({
        "merchantId":
            Firestore.instance.collection("users").document(user.id).documentID
      });
    });
    _navigateToMerchantHomeView();
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
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _navigateToMerchantHomeView),
        title: Center(
          child: Text('Add Coupon'),
        ),
      ),
      body: Material(
          child: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (String str) {
                    setState(() {
                      code = str;
                    });
                  },
                  decoration: new InputDecoration(
                      icon: Icon(Icons.title), hintText: "Coupon Name"),
                ),
              ),
              Padding(
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

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _pointController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.control_point),
                    hintText: "Enter points number",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),

              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: selectRadio,
                        onChanged: (val) {
                          setState(() {
                            selectedImageUrl = imageUrl1;
                          });
                          setSelectedRadio(val);
                        },
                      ),
                      Container(
                        width: 125,
                        height: 125,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(imageUrl1),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Radio(
                        value: 2,
                        groupValue: selectRadio,
                        onChanged: (val) {
                          setState(() {
                            selectedImageUrl = imageUrl2;
                          });
                          setSelectedRadio(val);
                        },
                      ),
                      Container(
                        width: 125,
                        height: 125,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(imageUrl2),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Radio(
                        value: 3,
                        groupValue: selectRadio,
                        onChanged: (val) {
                          setState(() {
                            selectedImageUrl = imageUrl3;
                          });
                          setSelectedRadio(val);
                        },
                      ),
                      Container(
                        width: 125,
                        height: 125,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(imageUrl3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      _addData(widget.user);
                    },
                    child: Text('Add'),
                  ),
                  RaisedButton(
                    onPressed: _navigateToMerchantHomeView,
                    child: Text('Cancel'),
                  )
                ],
              )

//          new Padding(
//              padding: const EdgeInsets.all(16.0),
//            child: ,
//          )
            ],
          ),
        ),
      )),
    );
  }
}
