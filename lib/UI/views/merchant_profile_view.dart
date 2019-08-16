import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/shared/ui_reducers.dart';
import 'package:giver_app/UI/widgets/coupon_status.dart';
import 'package:giver_app/UI/widgets/merchant_image.dart';
import 'package:giver_app/UI/widgets/merchant_info.dart';
import 'package:giver_app/UI/widgets/simple_toolbar.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/merchant_profile_view_model.dart';
import 'package:giver_app/UI/views/base_view.dart';
import 'package:giver_app/enum/view_state.dart';

class MerchantProfileView extends StatelessWidget {
  const MerchantProfileView({@required this.merchant, @required this.customer});
  final User customer;
  final User merchant;

  @override
  Widget build(BuildContext context) {
    return BaseView<MerchantProfileViewModel>(
        builder: (context, child, model) =>
            Stack(overflow: Overflow.clip, children: <Widget>[
              MerchantImage(
                merchant: merchant,
              ),
              Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  ),
                  body: Column(
                    children: <Widget>[
                      Container(
                        height: 70,
                      ),
                      Container(
                        height: 100,
                        child: MerchantInfo(
                          merchant: merchant,
                        ),
                      ),
                      Container(
                          height: screenHeight(context,
                              decreasedBy: 195.143 + toolbarHeight),
                          child: _getBodyUi(context, model)),
                    ],
                  ))
            ]));
  }

  Widget _getBodyUi(BuildContext context, MerchantProfileViewModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return _getLoadingUi(context);
      case ViewState.NoDataAvailable:
        return _noDataUi(context, model);
      case ViewState.Error:
        return _errorUi(context, model);
      case ViewState.DataFetched:
        return _getListUi(model);
      default:
        return _getListUi(model);
    }
  }
  ListTile makeListTile(Coupon coupon) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.autorenew, color: Colors.white),
          ),
          title: Text(
            coupon.code,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(coupon.description,
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            
          },
        );

    Card makeCard(Coupon coupon) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(coupon),
          ),
        );

  Widget _getListUi(MerchantProfileViewModel model) {
    List<Coupon> coupons = model.getCouponsByMerchantID(merchant.id);
    return ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, itemIndex) {
          var couponItem = coupons[itemIndex];
          return _getCouponItem(model, couponItem);
        });
  }

  //du ma met fvai lon
  Widget _getLoadingUi(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        Text('Fetching data ...')
      ],
    ));
  }

  Widget _noDataUi(BuildContext context, MerchantProfileViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, MerchantProfileViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  Widget _getCenteredViewMessage(
      BuildContext context, String message, MerchantProfileViewModel model,
      {bool error = false}) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                error
                    ? Icon(
                        // WWrap in gesture detector and call you refresh future here
                        Icons.refresh,
                        color: Colors.white,
                        size: 45.0,
                      )
                    : Container()
              ],
            )));
  }

  Widget _getCouponItem(MerchantProfileViewModel model, Coupon couponItem) {
    double _height = 70.0;
    const descriptionPadding = 15.0;
    bool _showDetails = false;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
      width: double.infinity,
      height: _height,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: Colors.grey),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                print('taptap');

                if (!_showDetails) {
                  _height = 190;
                } else {
                  _height = 70.0;
                }
              },
              child: Container(
                color: Colors.grey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      couponItem.description,
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _showDetails
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: descriptionPadding),
                            child: Text(couponItem.ownedBy),
                          )
                        : Container(),
                    Expanded(
                        child: Align(
                            child: CouponStatus(
                                status: (couponItem.isUsed
                                    ? 3
                                    : couponItem.isPending ? 2 : 1)),
                            alignment: Alignment.bottomLeft))
                  ],
                ),
              ),
            ),
          ),
          Container(
              width: 200,
              child: Column(children: <Widget>[
                (couponItem.usedBy.isEmpty)
                    ? FlatButton(
                        child: Text('Use Coupon'),
                        onPressed: () =>
                            model.redeemCoupon(couponItem.id, customer.id))
                    : Container(),
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('Today',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 9))))
              ])),
        ],
      ),
    );
  }
}
