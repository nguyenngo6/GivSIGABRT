




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class MerchantImage extends StatefulWidget {

  const MerchantImage({
    @required this.merchantSnapshot
  });

  final DocumentSnapshot merchantSnapshot;

  @override
  _MerchantImageState createState() => _MerchantImageState();
}

class _MerchantImageState extends State<MerchantImage> {
  
  double _height = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: new AssetImage("assets/logo.png"),
          fit: BoxFit.cover,
        )
      ),
      child: null ,
    );
  }
}