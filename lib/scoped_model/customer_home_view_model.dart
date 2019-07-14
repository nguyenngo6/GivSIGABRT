
import 'package:flutter/cupertino.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/enum/view_state.dart';

import '../service_locator.dart';

class CustomerHomeViewModel extends BaseModel {

  FirebaseService _firebaseService = getit<FirebaseService>();

  List<Coupon> coupons;
  List<User> merchants;
  List<Charity> charities;



  CustomerHomeViewModel() {
    _firebaseService.merchants.listen(_onMerchantUpdated);
    _firebaseService.charities.listen(_onCharityUpdated);
    _firebaseService.coupons.listen(_onCouponUpdated);

  }

  void _onMerchantUpdated(List<User> merchant) {
    merchants = merchant;
    if (merchants == null) {
      setState(ViewState.Busy);
    } else {
      setState(merchants.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
  }

  void _onCharityUpdated(List<Charity> charity) {
    charities = charity;
    if (charities == null) {
      setState(ViewState.Busy);
    } else {
      setState(charities.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
  }

  void _onCouponUpdated(List<Coupon> coupon) {
    coupons = coupon;
    if (coupons == null) {
      setState(ViewState.Busy);
    } else {
      setState(ViewState.DataFetched);
    }
  }

  List<Coupon> getCouponsByMerchantId(List<Coupon> coupons,String merchantId){
    var couponList = List<Coupon>();
    for(Coupon coupon in coupons){
      if(coupon.ownedBy == merchantId){
        couponList.add(coupon);
      }
    }
    return couponList;
  }

}