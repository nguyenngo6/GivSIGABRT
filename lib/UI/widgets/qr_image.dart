import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrWidget extends StatelessWidget {
  const QrWidget({@required this.couponID});

  final String couponID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coupon QR code"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Scan this to redeem ",
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
