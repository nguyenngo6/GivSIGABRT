import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:giver_app/UI/shared/draw_horizontal_line.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/UI/shared/ui_reducers.dart';
import 'package:giver_app/UI/views/customer_home_view.dart';
import 'package:giver_app/UI/widgets/coupon_info_item.dart';
import 'package:giver_app/UI/widgets/coupon_item.dart';
import 'package:giver_app/UI/widgets/merchant_item.dart';
import 'package:giver_app/UI/widgets/simple_toolbar.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/qr_scan_view_model.dart';

import 'base_view.dart';

class QrScanView extends StatefulWidget {
  const QrScanView({@required this.customer});

  final User customer;

  @override
  State<StatefulWidget> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  String barcode = "";
  bool isValid = false;
  Coupon scannedCoupon;
  User merchant;
  @override
  Widget build(BuildContext context) {
    return BaseView<QrScanViewModel>(
        builder: (context, child, model) => Scaffold(
              appBar: AppBar(
                title: Text('QR Code Scan'),
                leading: FlatButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    _resetData();
                    model.setState(ViewState.DataFetched);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerHomeView(
                                  user: widget.customer,
                                )));
                  },
                ),
              ),
              body: Container(
                  height: screenHeight(context, decreasedBy: toolbarHeight),
                  child: _getBodyUi(context, model)),
            ));
  }

  Widget _getBodyUi(BuildContext context, QrScanViewModel model) {
    switch (model.state) {
      case ViewState.InvalidCoupon:
        return _getInvalidCouponUi(context, model);
      case ViewState.CouponDataReceived:
        return getCouponInfoWidget(model, merchant, scannedCoupon);
      case ViewState.WrongQrFormat:
        return _getWrongQrFormatUi(model);
      case ViewState.WaitingForInput:
        return _getDefaultUi(model);
      case ViewState.Error:
        return _getErrorWidget(context, model);
      default:
        return _getDefaultUi(model);
    }
  }

  Widget _getWrongQrFormatUi(QrScanViewModel model) {
    return AlertDialog(
      title: Text('Format Error'),
      content: Text('This format is not supported'),
      actions: <Widget>[
        FlatButton(
            child: Text('Close'),
            onPressed: () {
              _resetData();
              model.setState(ViewState.WaitingForInput);
            })
      ],
    );
  }

  Widget _getInvalidCouponUi(BuildContext context, QrScanViewModel model) {
    return AlertDialog(
      title: Text('Invalid Input'),
      content: Text('This is not a valid Coupon'),
      actions: <Widget>[
        FlatButton(
            child: Text('Close'),
            onPressed: () {
              _resetData();
              model.setState(ViewState.WaitingForInput);
            })
      ],
    );
  }

  Widget getCouponInfoWidget(
      QrScanViewModel model, User merchant, Coupon coupon) {
    // return Container(
    //   child: CouponInfoItem(
    //       coupon: coupon,
    //       merchant: merchant,
    //       onRedeemed: () => showConfirmationDialog(model, coupon)         
    //       ),
    // );
    return Container(  
      margin: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[_getCouponInfoBody(model, coupon), _getCouponInfoHeader()],
      ),
    );
  }
  showConfirmationDialog(QrScanViewModel model, Coupon coupon) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure to use this coupon'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    
                    model.onCouponRedeemed(coupon.id, widget.customer.id);
                    _resetData();
                    model.setState(ViewState.WaitingForInput);
                    Navigator.pop(context);
                  },
                  child: Text('Ok')),
              FlatButton(
                onPressed: () {
                  _resetData();
                  Navigator.pop(context);
                  model.setState(ViewState.WaitingForInput);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  Widget _getErrorWidget(BuildContext context, QrScanViewModel model) {
    return AlertDialog(
      title: Text('Error'),
      content: Text('Something went wrong'),
      actions: <Widget>[
        FlatButton(
            child: Text('Close'),
            onPressed: () {
              _resetData();
              model.setState(ViewState.WaitingForInput);
            })
      ],
    );
  }

  Widget _getDefaultUi(QrScanViewModel model) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            height: 150,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10.0),
            child: RaisedButton(
              color: Colors.amber,
              textColor: Colors.black,
              splashColor: Colors.blueGrey,
              onPressed: () => scan(model),
              child: const Text('Press to start scanning'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              barcode,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  _resetData() {
    this.scannedCoupon = null;
    this.barcode = "";
    this.merchant = null;
    this.isValid = false;
  }

  Future scan(QrScanViewModel model) async {
    try {
      this.barcode = await BarcodeScanner.scan();
      // this.barcode = "-LjoOTKKlabjuoZ14Yhj";
      // await new Future.delayed(new Duration(milliseconds: 100));
      this.isValid = await model.onDataReceived(barcode);
      if (isValid) {
        this.scannedCoupon = await model.getCouponFromBarcode(barcode);
        this.merchant = await model.getMerchantFromCoupon(scannedCoupon);
        if (this.scannedCoupon != null && this.merchant != null) {
          model.setState(ViewState.CouponDataReceived);
        } else {
          model.setState(ViewState.Error);
        }
      } else {
        model.setState(ViewState.InvalidCoupon);
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        model.setState(ViewState.Error);
      } else {
        //do nothing
      }
    } on FormatException {
      model.setState(ViewState.WrongQrFormat);
    } catch (e) {
      //do nothing
    }
  }
  Widget _getCouponInfoHeader() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        alignment: FractionalOffset.topCenter,
        child: Hero(
          tag: "tag",
          child: Image(
            image: AssetImage("assets/logo.png"),
            height: 92,
            width: 92,
          ),
        ));
  }

  Widget _getCouponInfoBody(QrScanViewModel model, Coupon coupon) {
    return Container(
      constraints: BoxConstraints.expand(),
      margin: EdgeInsets.only(top: 46),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 80,
          ),
          Text(
            merchant.username,
            style: Style.headerTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
            height: 10,
          ),
          Text(
            merchant.address, 
            style: Style.commonTextStyle,
            textAlign: TextAlign.center,
          ),

          Container(
            height: 20,
          ),
          Container(
            height: 20,
            child: CustomPaint(
              painter: DrawHorizontalLine(),
            ),
          ),
          Text(
            "Coupon Code",
            style: Style.commonTextStyle,
          ),
          Container(
            height: 30,
          ),
          Text(
            coupon.code,
            style: Style.couponCodeTextStyle,
          ),
          Container(
            height: 30,
          ),
          Text(
            coupon.description,
            style: Style.commonTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
            height: 30,
          ),
          ButtonTheme(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            minWidth: 200,
            child: RaisedButton(
              child: Text(
                "Redeem Now",
                style: Style.infoTextStyle,
              ),
              onPressed: () => showConfirmationDialog(model, coupon),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
