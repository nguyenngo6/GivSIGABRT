
import 'package:flutter/cupertino.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/enum/view_state.dart';

import '../service_locator.dart';

class MerchantProfileViewModel extends BaseModel {

  FirebaseService _firebaseService = getit<FirebaseService>();
  List<Coupon> coupons;

  MerchantProfileViewModel() {
    _firebaseService.coupons.listen(_onCouponUpdated);
  }

  void redeemCoupon({@required String couponID}){
    _firebaseService.redeemCoupon(couponID: couponID);
  }

  void _onCouponUpdated(List<Coupon> coupon) {
    coupons = coupon;

    if (coupons == null) {
      setState(ViewState.Busy);   
    } else {
      setState(coupons.length == 0 
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
  }

}