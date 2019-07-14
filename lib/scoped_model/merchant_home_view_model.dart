
import 'package:flutter/cupertino.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/enum/view_state.dart';
import '../service_locator.dart';

class MerchantHomeViewModel extends BaseModel {

  FirebaseService _firebaseService = locator<FirebaseService>();
  List<Coupon> ownedCoupons;
  
  MerchantHomeViewModel() {
    _firebaseService.coupons.listen(_onCouponUpdated);
  }

  void redeemCoupon({@required String couponID}){
    _firebaseService.redeemCoupon(couponID: couponID);
  }

 List<Coupon> getMerchantOwnedCoupon(String merchantID) {
    for (Coupon coupon in ownedCoupons) {
      if (coupon.ownedBy != merchantID) {
        ownedCoupons.remove(coupon);
      }
    }
    
    return ownedCoupons;
  }


  void _onCouponUpdated(List<Coupon> coupon) {
    ownedCoupons = coupon;

    if (ownedCoupons == null) {
      setState(ViewState.Busy);   
    } else {
      setState(ownedCoupons.length == 0 
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
  }

}

