import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:giver_app/UI/views/customer_home_view.dart';
import 'package:giver_app/UI/widgets/coupon_item.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/qr_scan_view_model.dart';

import 'base_view.dart';

class QrScanView extends StatefulWidget {
  const QrScanView({@required this.customer});

  final User customer;

  @override
  State<StatefulWidget> createState() =>  _QrScanViewState();
  
}

class _QrScanViewState extends State<QrScanView> {
  String barcode = "";
  bool isValid = false;
  @override
  Widget build(BuildContext context) {
    return BaseView<QrScanViewModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scan'),
          leading: FlatButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {  
              barcode = "";
              isValid = false;
              model.setState(ViewState.DataFetched);
              Navigator.
              pushReplacement(context, MaterialPageRoute(
                builder: (context) => CustomerHomeView(user: widget.customer,)
              ));
              },
          ),
        ),
        body: _getBodyUi(context, model)
        )
    );
  }

  Widget _getBodyUi(BuildContext context, QrScanViewModel model) {
    switch(model.state){
      case ViewState.InvalidCoupon:
        return _getInvalidCouponUi();
      case ViewState.CouponDataReceived:
        return _getCouponInfoWidget(model);
      case ViewState.WrongQrFormat:
        return _getWrongQrFormatUi();
      case ViewState.WaitingForInput:
        return _getDefaultUi(model);
      default:
        return _getDefaultUi(model);
    }
  }

  Widget _getWrongQrFormatUi(){
    return Container(child: Text('Wrong Qr Format'),);
  }

  Widget _getInvalidCouponUi(){
    return Container(child: Text("invalid coupon"),);
  }
  
  Widget _getCouponInfoWidget(QrScanViewModel model){   
      return Container(
        height: 400,
        width: 300,
        child: Column(
          children: <Widget>[
            Text('$barcode'),
            FlatButton(
              child: Text('Use this coupon'),
              onPressed: () => _showConfirmationDialog(model),
            )
          ],
        ),
      );
  }

  Widget _getErrorWidget(BuildContext context, QrScanViewModel model){
    return AlertDialog(
      title: Text('Error'),
      content: Text('Something went wrong'),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () => Navigator.pop(context),
            
            )

          
      ],
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
                        barcode,
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
      this.barcode = await BarcodeScanner.scan();      
      this.isValid = await model.onDataReceived(barcode);
      if(isValid){
        model.setState(ViewState.CouponDataReceived);
      }
        else{
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

  _showConfirmationDialog(QrScanViewModel model) {

    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure to use this coupon'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    model.onCouponRedeemed(barcode, widget.customer.id);
                    barcode = "";
                    isValid = false;
                    model.setState(ViewState.DataFetched);
                    Navigator.pushReplacement(
                      context, MaterialPageRoute(
                        builder: (context) => CustomerHomeView(user: widget.customer,)));
                  },
                  child: Text('Ok')),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        }); 

  }


  
  


  
  

    
  
}


