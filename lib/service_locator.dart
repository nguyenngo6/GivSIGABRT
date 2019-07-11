    
import 'package:get_it/get_it.dart';
import 'package:giver_app/scoped_model/merchant_profile_view_model.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/home_view_model.dart';


GetIt getit = new GetIt();

void setupLocator() {
  // Register services
  getit.registerLazySingleton(() => FirebaseService());
  getit.registerFactory<HomeViewModel>(() => new HomeViewModel());
  getit.registerSingleton(MerchantProfileViewModel());
  
}