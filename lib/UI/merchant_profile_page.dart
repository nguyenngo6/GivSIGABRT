import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/model/coupon.dart';

class MerchantProfilePage extends StatefulWidget {
  @override
  _MerchantProfilePageState createState() => _MerchantProfilePageState();
}

class _MerchantProfilePageState extends State<MerchantProfilePage> {
  
  Future getCoupons() async {
    CollectionReference couponReference = Firestore.instance.collection("users");
    QuerySnapshot qn = await couponReference.getDocuments();    

    return qn.documents;        
  }

//  navigateToCoupon(DocumentSnapshot coupon) {
//    Navigator.push(context, MaterialPageRoute(builder: (context) => Coupon()));
//  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('merchant'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: Text('Tommy Hilfiger',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0
                 ),
                 ),
               ),
              Padding(
                 padding: const EdgeInsets.only(left:20.0, top: 20.0, right: 20.0),
                 child: Text('San Francisco, CA',
                 style: TextStyle(
                   fontFamily: 'Montserrat',
                   color: Colors.grey,
                   fontSize: 15.0
                 ),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(left:20.0, top: 20.0, right: 20.0),
                 child: Text('We sell women and men clothes',
                 style: TextStyle(
                   fontFamily: 'Montserrat',
                   fontWeight: FontWeight.w300,
                   fontSize: 15.0
                 ),
                 ),
               ),
               SizedBox(height: 25),
               Container(
                 padding: const EdgeInsets.only(left:20.0, top: 20.0, right: 20.0),
                 height: 150,
                 width: 300,
                 child: FutureBuilder(
                   future: getCoupons(),
                   builder: (_, snapshot){
                     if (snapshot.connectionState == ConnectionState.waiting){
                       return Center(
                         child: Text('Loading...'),
                       );
                     } else {
                       return ListView.builder(
                         
                         itemCount:  snapshot.data.length,
                         itemBuilder: (_, index){
                           return ListTile(
                             title: Text(snapshot.data[index].data['email']),
//                             onTap: () => navigateToCoupon(snapshot.data[index]),
                           );
                         },
                       );
                     }
                   },
                 ),
                 
                  
               )
            ],
          )
        ],
      ),
    );
  }
}