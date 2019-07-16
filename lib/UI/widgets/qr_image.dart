import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrWidget extends StatelessWidget {

  const QrWidget({@required this.couponID});
  
  final String couponID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Código QR"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Código gerado com o texto:\n $couponID",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16,),

            QrImage(
              data: couponID,
              gapless: true,
              size: 250,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            )
          ],
        ),
      ),
    );
  }
}