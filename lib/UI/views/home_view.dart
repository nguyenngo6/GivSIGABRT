import 'package:giver_app/UI/views/merchant_profile_view.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/service_locator.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/scoped_model/home_view_model.dart';
import 'package:giver_app/UI/views/base_view.dart';


class HomeView extends StatelessWidget {
  static const BoxDecoration topLineBorderDecoration = BoxDecoration(
      border: Border(
          top: BorderSide(
              color: Colors.grey, style: BorderStyle.solid, width: 5.0)));

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
        builder: (context, child, model) => Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: FlatButton(child: Text('Merchant'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MerchantProfileView()));
            }),

        ));
  }


}