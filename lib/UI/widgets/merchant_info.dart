
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/model/user.dart';
import 'package:meta/meta.dart';

class MerchantInfo extends StatefulWidget {

  const MerchantInfo({
    @required this.merchant
  });

  final User merchant;
    
  @override
  _MerchantInfoState createState() => _MerchantInfoState();
}

class _MerchantInfoState extends State<MerchantInfo> {
  double _height = 70;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        
        title: Text(widget.merchant.username),
        
        subtitle: Row(
          
          children: <Widget>[
            Icon(
              Icons.gps_fixed
            ),
            Text(widget.merchant.phone)
            
          ],
        ),
      )
      
      
      
    );
  }
}