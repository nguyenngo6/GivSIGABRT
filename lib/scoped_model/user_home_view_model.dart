
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/enum/view_state.dart';
export 'package:giver_app/enum/view_state.dart';


import '../service_locator.dart';

class UserHomeViewModel extends BaseModel {

  FirebaseService _firebaseService = locator<FirebaseService>();

  List<Coupon> coupons;
  List<User> merchants;
  List<User> customers;
  List<Charity> charities;



  UserHomeViewModel() {
    _firebaseService.customers.asBroadcastStream().listen(_onCustomerUpdated);
    _firebaseService.merchants.asBroadcastStream().listen(_onMerchantUpdated);
    _firebaseService.charities.asBroadcastStream().listen(_onCharityUpdated);
    _firebaseService.coupons.asBroadcastStream().listen(_onCouponUpdated);

  }

  User getCurrentUser(List<User> merchants,String id){
    this.setState(ViewState.Busy);
    User currentUser;
    for (User user in merchants){
        if (user.id == id ){
          currentUser = user;
        }
      }
    this.setState(ViewState.DataFetched);
    return currentUser;
  }

  void _onCustomerUpdated(List<User> customer) {
    setState(ViewState.Busy);
    customers = customer;
    if (customers == null) {
      setState(ViewState.Busy);
    } else {
      setState(customers.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
  }

  void _onMerchantUpdated(List<User> merchant) {
    setState(ViewState.Busy);
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
    setState(ViewState.Busy);
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
    setState(ViewState.Busy);
    coupons = coupon;
    if (coupons == null) {
      setState(ViewState.Busy);
    } else {
      setState(ViewState.DataFetched);
    }
  }

  List<Coupon> getCouponsByMerchantId(List<Coupon> coupons,String merchantId){
    setState(ViewState.Busy);
    var couponList = List<Coupon>();
    for(Coupon coupon in coupons){
      if(coupon.ownedBy == merchantId){
        couponList.add(coupon);
      }
    }
    setState(ViewState.DataFetched);
    return couponList;
  }

}