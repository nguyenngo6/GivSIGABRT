import 'package:flutter/material.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/scoped_model/customer_history_view_model.dart';

class CouponHistory extends StatefulWidget {
  final CustomerHistoryViewModel model;
  final String uid;
  CouponHistory({@required this.model, @required this.uid});
  @override
  _CouponHistoryState createState() => _CouponHistoryState();
}

class _CouponHistoryState extends State<CouponHistory> {
  double _height = 70.0;
  static const double descriptionPadding = 15.0;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    List<Coupon> coupons = widget.model.getUsedCoupons(widget.model.couponList, widget.uid);
    return Scaffold(
      body: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, rowNumber) {
          var coupon = coupons[rowNumber];
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: double.infinity,
            height: _height,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0), color: Colors.grey),
            child: Row(
              children: <Widget>[_detailSection(coupon)],
            ),
          );
        },
      ),
    );
  }

  Widget _detailSection(Coupon coupon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          print('tap'+ _showDetails.toString());
          setState(() {
            _showDetails = !_showDetails;
            if (_showDetails) {
              _height = 150.0;
            } else {
              _height = 70.0;
            }
          });
        },
        child: Container(
          color: Colors.grey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                coupon.description,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _showDetails
                  ? Text('details')
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}


