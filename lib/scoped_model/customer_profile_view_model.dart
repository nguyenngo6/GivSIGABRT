
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


  CustomerProfileViewModel() {
    _firebaseService.customers.asBroadcastStream().listen(_onCustomerUpdated);
  }

  Future<bool> onUsernameEdited(String newUsername, String uid)async{
    setState(ViewState.Busy);
    await _firebaseService.editUsername(newUsername, uid);
    await Future.delayed(Duration(seconds: 2));
    setState(ViewState.DataFetched);

    return true;
  }

  User getCurrentUser(List<User> userList, String id) {
    User currentUser;
    for (User user in userList){
      if (user.id == id ){
        currentUser = user;
      }
    }
    return currentUser;
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