import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/qr_scan_view_model.dart';

import 'base_view.dart';
enum ConfirmAction { CANCEL, ACCEPT }

class QrScanView extends StatefulWidget {
  const QrScanView({@required this.customer});

  final User customer;

  @override
  State<StatefulWidget> createState() =>  _QrScanViewState();
  
}

class _QrScanViewState extends State<QrScanView> {
  String _barcode = "";
  @override
  Widget build(BuildContext context) {
    return BaseView<QrScanViewModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scan'),
        ),
        body: _getBodyUi(context, model)
        )
    );
  }

  Widget _getBodyUi(BuildContext context, QrScanViewModel model) {
    switch(model.state){
      case ViewState.InvalidCoupon:
        return _getErrorWidget();
      case ViewState.Confirmation:
        return _getConfirmationWidget(model);
      case ViewState.Error:
        return _getErrorWidget();
      case ViewState.WrongQrFormat:
        return _getErrorWidget();
      default:
        return _getDefaultUi(model);
    }
  }
  

  Widget _getConfirmationWidget(QrScanViewModel model){
    _asyncConfirmDialog(context, model, _barcode);
    return Container(
      child: Text("Success!"),
    );
  }

  Widget _getErrorWidget(){
    return Container(
      child: Text("Error"),
    );
  }

  Widget _getDefaultUi(QrScanViewModel model){
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 10.0),
                      child: RaisedButton(
                        color: Colors.amber,
                        textColor: Colors.black,
                        splashColor: Colors.blueGrey,
                        onPressed: () => scan(model),
                        child: const Text('Press to start scanning'),
                      ),
                    ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        _barcode,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
            ],
          ),
        );
  }

  Future scan(QrScanViewModel model) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this._barcode = barcode;
      });
      model.onDataReceived(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
          model.setState(ViewState.Error);
      } else {
        model.setState(ViewState.Error);
      }
    } on FormatException {
      model.setState(ViewState.WrongQrFormat);
    } catch (e) {
      model.setState(ViewState.Error);
    }
  }
  
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, QrScanViewModel model, String couponID) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Use this coupon?'),
        content: const Text(
            'This will move the coupon to your pending list'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('ACCEPT'),
            onPressed: () {
              model.onCouponRedeemed(couponID, widget.customer.id);
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}


}