
import 'package:giver_app/service_locator.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/coupon.dart';
class MerchantViewModel extends BaseModel {

  FirebaseService _firebaseService = locator<FirebaseService>();
  List<Coupon> activeCoupons;


}