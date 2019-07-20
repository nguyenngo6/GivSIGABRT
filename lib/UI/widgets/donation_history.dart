import 'package:flutter/material.dart';
import 'package:giver_app/scoped_model/customer_history_view_model.dart';

class DonationHistory extends StatelessWidget {
  final CustomerHistoryViewModel model;
  final String uid;

  DonationHistory({@required this.model, @required this.uid});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('donation history'),
    );
  }
}
