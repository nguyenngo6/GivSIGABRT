import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MerchantHomePage extends StatefulWidget {
  const MerchantHomePage ({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _MerchantHomePageState createState() => _MerchantHomePageState();

}

class _MerchantHomePageState extends State<MerchantHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merchant ${widget.user.email}'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
         stream: Firestore.instance.collection('users').document(widget.user.uid).snapshots(), builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if(snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }
            switch(snapshot.connectionState) {
              case ConnectionState.waiting: return Text('Loading..');
              default:
               return Text(snapshot.data.data['email']);
           }
        },
      ),
    );
  }

  
}
