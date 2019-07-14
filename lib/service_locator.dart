    
import 'package:get_it/get_it.dart';
import 'package:giver_app/scoped_model/merchant_home_view_model.dart';
import 'package:giver_app/scoped_model/merchant_profile_view_model.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/home_view_model.dart';
import 'package:giver_app/user_repository.dart';


GetIt locator = new GetIt();

void setupLocator() {
  // Register services
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerFactory<HomeViewModel>(() => new HomeViewModel());
  locator.registerSingleton(MerchantProfileViewModel()); 
}