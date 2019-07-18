
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/scoped_model/base_model.dart';

import '../service_locator.dart';

class QrScanViewModel extends BaseModel {
  FirebaseService _firebaseService = locator<FirebaseService>();
  List<Coupon> coupons;

  QrScanViewModel() {
    _firebaseService.coupons.asBroadcastStream().listen(_onCouponUpdated);   
  }


  void onCouponRedeemed(String couponID, String customerID){
    _firebaseService.moveCouponToPending(couponID, customerID);
  }

  Future<bool> onDataReceived(String scannedData) async {
    Coupon scannedCoupon;
    for(Coupon c in coupons){
      if (c.id == scannedData){
        scannedCoupon = c;
        if (scannedCoupon.isPending){
          return false;
        }
        else {
          return true;
        }
      }
    }
    return false;

  }

  void _onCouponUpdated(List<Coupon> coupon) {
    coupons = coupon;    
    if (coupons == null) {
      setState(ViewState.Busy);   
    } else {
      setState(coupons.length == 0 
          ? ViewState.NoDataAvailable
          : ViewState.WaitingForInput);
    }
  }




}
