import 'package:flutter/material.dart';

import '../../model/user.dart';
import '../../scoped_model/user_home_view_model.dart';
import '../views/merchant_profile_view.dart';

class MerchantList extends StatefulWidget {
  final User customer;
  final UserHomeViewModel model;
  MerchantList({@required this.model, @required this.customer});
  @override
  _MerchantListState createState() => _MerchantListState();
}

class _MerchantListState extends State<MerchantList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: widget.model.merchants.length,
              itemBuilder: (context, rowNumber) {
                var merchants = widget.model.merchants;
                var merchant = merchants[rowNumber];
                return Container(
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                            child: InkWell(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MerchantProfileView(
                                          merchant: merchant,
                                          customer: widget.customer))),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch, // add this
                                children: <Widget>[
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      child: Image.network(merchant.imageUrl,
                                          // width: 300,
                                          fit: BoxFit.fill),
                                    ),
                                    flex: 8,
                                  ),
                                  Expanded(
                                    child:
                                    Center(child: Text(merchant.username)),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ))));
              }),
          flex: 9,
        ),
      ],
    );
  }
}
