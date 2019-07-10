

import 'package:get_it/get_it.dart';
import 'package:giver_app/services/firebase_service.dart';

GetIt locator = new GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerSingleton(MerchantViewModel());
}
