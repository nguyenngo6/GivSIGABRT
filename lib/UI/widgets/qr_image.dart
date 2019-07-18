import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrWidget extends StatelessWidget {

  const QrWidget({@required this.couponID});
  
  final String couponID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Image"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Coupon ID:\n ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 30,),
            QrImage(
              data: couponID,
              gapless: true,
              size: 500,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            )
          ],
        ),
      ),
    );
  }
}