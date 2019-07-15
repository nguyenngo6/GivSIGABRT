    
import 'package:get_it/get_it.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';
import 'package:giver_app/scoped_model/customer_profile_view_model.dart';
import 'package:giver_app/scoped_model/merchant_profile_view_model.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/home_view_model.dart';



GetIt locator = new GetIt();

void setupLocator() {
  // Register services
  locator.registerLazySingleton(() => FirebaseService());


  locator.registerSingleton(HomeViewModel());
  locator.registerSingleton(UserHomeViewModel());
  locator.registerSingleton(MerchantProfileViewModel());
  locator.registerSingleton(CustomerProfileViewModel());
 
}