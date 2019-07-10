  import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:meta/meta.dart';


class FirebaseService {
  final StreamController<List<Coupon>> _couponController = StreamController<List<Coupon>>();

  FirebaseService() {
    Firestore.instance.
        collection("coupons").
        snapshots().
        listen(_couponAdded);
  }

  Stream<List<Coupon>> get coupons => _couponController.stream;
  
  void _couponAdded(QuerySnapshot snapshot) {
    var coupon = _getCouponFromSnapshot(snapshot);
    _couponController.add(coupon);
    
  }

  List<Coupon> _getCouponFromSnapshot(QuerySnapshot snapshot) {
    var couponItems = List<Coupon>();
    var documents = snapshot.documents;
    var hasDocuments = documents.length > 0;

    if(hasDocuments) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        couponItems.add(Coupon.fromData(documentData));
        _excludeUsedCoupons(couponItems);
      }
    }

    return couponItems;
   }

   void _excludeUsedCoupons(List<Coupon> couponItems){
     for (Coupon coupon in couponItems) {
       if (coupon.isUsed) {
         couponItems.remove(coupon);
       }
     }
   }
}