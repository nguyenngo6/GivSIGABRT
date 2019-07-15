
import 'package:flutter/cupertino.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/enum/view_state.dart';

import '../service_locator.dart';

class CustomerProfileViewModel extends BaseModel {


  FirebaseService _firebaseService = locator<FirebaseService>();

  List<User> customers;
  User customer;


  CustomerProfileViewModel() {
    _firebaseService.customers.asBroadcastStream().listen(_onCustomerUpdated);
  }

  User getCustomerByUid(List<User> customers ,String uid){
    for(User customer in customers){
      if(customer.id == uid){
        return customer;
      }
    }
  }

  void _onCustomerUpdated(List<User> customer) {
    customers = customer;
    if (customers == null) {
      setState(ViewState.Busy);
    } else {
      setState(ViewState.DataFetched);
    }
  }
}