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
<<<<<<< HEAD
            Text("Coupon ID:\n ",
=======
            Text(
              "Coupon ID:\n $couponID",
>>>>>>> c03253509cbe4088548e7061f19a7fb5ee9b7926
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
<<<<<<< HEAD
            SizedBox(height: 30,),
=======
            SizedBox(
              height: 16,
            ),
>>>>>>> c03253509cbe4088548e7061f19a7fb5ee9b7926
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
