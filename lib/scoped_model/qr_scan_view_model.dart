
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

  Coupon onDataReceived(String scannedData){
    for (Coupon coupon in this.coupons) {
      if (coupon.id == scannedData){
        if(coupon.isUsed || coupon.isPending || coupon.usedBy != null){
        setState(ViewState.InvalidCoupon);
        } else {
          setState(ViewState.CouponDataReceived);
          return coupon;
        }
      } else {
        setState(ViewState.WrongQrFormat);
        return null;
      }
    }
    return null;
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
