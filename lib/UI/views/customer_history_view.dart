import 'package:flutter/material.dart';
import 'package:giver_app/scoped_model/customer_history_view_model.dart';
import '../../model/user.dart';
import 'base_view.dart';

class CustomerHistoryView extends StatefulWidget {
  final User customer;
  CustomerHistoryView({@required this.customer});
  @override
  _CustomerHistoryViewState createState() => _CustomerHistoryViewState();
}

class _CustomerHistoryViewState extends State<CustomerHistoryView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<CustomerHistoryViewModel>(
        builder: (context, child, model) => Scaffold());
  }
}
