import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/shared/ui_reducers.dart';
import 'package:giver_app/UI/widgets/merchant_image.dart';
import 'package:giver_app/UI/widgets/merchant_info.dart';

import 'package:giver_app/UI/widgets/simple_toolbar.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/merchant_profile_view_model.dart';
import 'package:giver_app/UI/views/base_view.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/UI/widgets/coupon_item.dart';

class MerchantProfileView extends StatelessWidget {

  const MerchantProfileView({@required this.merchant, @required this.customer});
  final User customer;
  final User merchant;

  @override
  Widget build(BuildContext context) {
    return BaseView<MerchantProfileViewModel>(
        builder: (context, child, model) => 
        Stack(
          children: <Widget>[
            MerchantImage(merchant: merchant,),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white,)),
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
                    height:
                        screenHeight(context, decreasedBy: 170 + toolbarHeight),
                    child: _getBodyUi(context, model)),
              ],
            )
            )]
            )
            );
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

  Widget _getListUi(MerchantProfileViewModel model) {
    return ListView.builder(
        itemCount: model.getCouponsByMerchantID(merchant.id).length,
        itemBuilder: (context, itemIndex) {
          var couponItem = model.getCouponsByMerchantID(merchant.id)[itemIndex];
          String couponID = couponItem.id;
          return CouponItem(
              customer: customer,
              couponItem: couponItem,
              onRedeemed: () => 
                model.redeemCoupon(couponID, customer.id)
              );
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
}
