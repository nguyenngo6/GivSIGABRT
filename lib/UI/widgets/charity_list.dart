import 'package:flutter/material.dart';

import '../../model/user.dart';
import '../../scoped_model/user_home_view_model.dart';
import 'busy_overlay.dart';

class CharityList extends StatefulWidget {
  final User customer;
  final UserHomeViewModel model;
  CharityList({@required this.model,@required this.customer});
  @override
  _CharityListState createState() => _CharityListState();
}

class _CharityListState extends State<CharityList> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: editingController,
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: BusyOverlay(
              show: widget.model.state == ViewState.Busy,
              child: Scaffold(
                body: Text('this is charityList'),
              )),
          flex: 9,
        ),
      ],
    );
  }
}
