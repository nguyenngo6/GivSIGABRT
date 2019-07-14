
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class MerchantInfo extends StatefulWidget {

  const MerchantInfo({
    @required this.merchantSnapshot
  });

  final DocumentSnapshot merchantSnapshot;
    
  @override
  _MerchantInfoState createState() => _MerchantInfoState();
}

class _MerchantInfoState extends State<MerchantInfo> {
  double _height = 70;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        
        title: Text(widget.merchantSnapshot.data['username']),
        
        subtitle: Row(
          
          children: <Widget>[
            Icon(
              Icons.gps_fixed
            ),
            Text(widget.merchantSnapshot.data['address'])
            
          ],
        ),
      )
      
      
      
    );
  }
}