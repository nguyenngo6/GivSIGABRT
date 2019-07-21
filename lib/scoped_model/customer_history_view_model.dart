import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/services/firebase_service.dart';
import '../service_locator.dart';
import 'base_model.dart';
export 'package:giver_app/enum/view_state.dart';


class CustomerHistoryViewModel extends BaseModel{
  FirebaseService _firebaseService = locator<FirebaseService>();
  List<Coupon> couponList;

  CustomerHistoryViewModel() {
    _firebaseService.coupons.listen(_onCouponUpdated);
  }

  void _onCouponUpdated(List<Coupon> coupon) {
    couponList = coupon;
    if (couponList == null) {
      setState(ViewState.Busy);
    } else {
      setState(ViewState.DataFetched);
    }
  }



  List<Coupon> getUsedCoupons(List<Coupon> couponList,String uid) {
    setState(ViewState.Busy);
    var finalList = List<Coupon>();
    for(Coupon coupon in couponList){
      if(coupon.isUsed == true && coupon.usedBy == uid){
        finalList.add(coupon);
      }
    }
    setState(ViewState.DataFetched);
    return finalList;
  }
}