
import 'package:flutter/cupertino.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/enum/view_state.dart';

import '../service_locator.dart';

class CustomerProfileViewModel extends BaseModel {


  FirebaseService _firebaseService = getit<FirebaseService>();

  List<User> customers;
  User customer;


  void setCustomer(User user){
    this.customer = user;
  }

  CustomerProfileViewModel() {
    _firebaseService.customers.listen(_onCustomerUpdated);

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