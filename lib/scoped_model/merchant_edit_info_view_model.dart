
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/enum/view_state.dart';
export 'package:giver_app/enum/view_state.dart';


import '../service_locator.dart';

class MerchantEditInfoViewModel extends BaseModel {

  FirebaseService _firebaseService = locator<FirebaseService>();
  List<Coupon> coupons;
 
  MerchantEditInfoViewModel() {
    _firebaseService.coupons.asBroadcastStream().listen(_onCouponUpdated);  
  }

  void redeemCoupon(String couponID, String customerID){
    _firebaseService.moveCouponToPending(couponID, customerID);
  }
  
  List<Coupon> getCouponsByMerchantID(String merchantID) {
    var result = List<Coupon>();
    for (Coupon coupon in coupons){
      if (coupon.ownedBy == merchantID) {
        if (coupon.usedBy.isEmpty) {
          result.add(coupon);
        }
      }
    }

    return result;
  }

  void updateMerchantData(String merchantId, String username, String phone, String address){
    _firebaseService.updateMerchantData(merchantId, username, phone, address);
  }
  
  Future<bool> onInfoEdited(String data, String uid)async{
    if(state == ViewState.EditUsername){
      setState(ViewState.Busy);
      await _firebaseService.editUsername(data, uid);
      await Future.delayed(Duration(seconds: 2));
      setState(ViewState.DataFetched);
    }else if(state == ViewState.EditPhone){
      setState(ViewState.Busy);
      await _firebaseService.editPhone(data, uid);
      await Future.delayed(Duration(seconds: 2));
      setState(ViewState.DataFetched);
    }else if(state == ViewState.EditImageUrl){
      setState(ViewState.Busy);
      await _firebaseService.editImageUrl(data, uid);
      await Future.delayed(Duration(seconds: 2));
      setState(ViewState.DataFetched);
    }


    return true;
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