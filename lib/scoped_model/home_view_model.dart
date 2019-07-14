import 'package:get_it/get_it.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/service_locator.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/scoped_model/home_view_model.dart';


import 'base_model.dart';

class HomeViewModel extends BaseModel {
  FirebaseService _firebaseService = locator<FirebaseService>();
  
  HomeViewModel() {
    
  }



}