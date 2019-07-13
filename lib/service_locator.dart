
import 'package:get_it/get_it.dart';
import 'package:giver_app/scoped_model/customer_home_view_model.dart';
import 'package:giver_app/scoped_model/customer_profile_view_model.dart';
import 'package:giver_app/services/firebase_service.dart';


GetIt getit = new GetIt();

void setupLocator() {
  // Register services
  getit.registerLazySingleton(() => FirebaseService());

  getit.registerSingleton(CustomerHomeViewModel());
  getit.registerSingleton(CustomerProfileViewModel());


}