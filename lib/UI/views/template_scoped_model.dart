import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/Views/sign_in_page.dart';
import 'package:giver_app/UI/views/merchant_profile_view.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/enum/view_state.dart';

import 'base_view.dart';
import 'customer_profile_view.dart';

class TemplateView extends StatefulWidget {
  @override
  _TemplateViewState createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<UserHomeViewModel>(
        builder: (context, child, model) => Scaffold());
  }
}
