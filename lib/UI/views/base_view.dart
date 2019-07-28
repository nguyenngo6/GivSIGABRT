import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../service_locator.dart';

class BaseView<T extends Model> extends StatefulWidget {
  final ScopedModelDescendantBuilder<T> _builder;
  final Function(T) onModelReady;
  final User user;

  /// Function will be called as soon as the widget is initialised.
  ///
  /// Callback will reive the model that was created and supplied to the ScopedModel

  BaseView({ScopedModelDescendantBuilder<T> builder, this.onModelReady, this.user})
      : _builder = builder;

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends Model> extends State<BaseView<T>> {
  T _model = locator<T>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FirebaseService _firebaseService = locator<FirebaseService>();
  Flushbar flush;
  bool _wasButtonClicked;

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(_model);
    }
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage : $message");
        // showDialog(
        //         context: context,
        //         builder: (context) => AlertDialog(
        //                 content: ListTile(
        //                 title: Text(message['notification']['title']),
        //                 subtitle: Text(message['notification']['body']),
        //                 ),
        //                 actions: <Widget>[
        //                   FlatButton(
        //                     child: Text('Approve'),
        //                     onPressed: () => _redeem(message['data']['cId'])),
        //                    FlatButton(
        //                     child: Text('Deny'),
        //                     onPressed: () => _deny(message['data']['cId'])),
        //                 FlatButton(
        //                     child: Text('Ok'),
        //                     onPressed: () => Navigator.of(context).pop(),
        //                 ),
        //             ],
        //         ),
        //     );
        if (message['data']['tag'] == 'approval' && widget.user.level == 2) {
          flush = Flushbar<bool>(
            title: message['notification']['title'],
            message: message['notification']['body'],
            duration: Duration(seconds: 5),
            mainButton: FlatButton(
              child: Text('Approve', style: TextStyle(color: Colors.amber)),
              onPressed: () {
                _redeem(message['data']['cId']);
                flush.dismiss(true);
              },
            ),
          )..show(context).then((result) {
              setState(() {
                _wasButtonClicked = true;
              });
            });
        }
        if (message['data']['tag'] == 'updateNotify' && widget.user.level == 1) {
          flush = Flushbar(
            title: message['notification']['title'],
            message: message['notification']['body'],
            duration: Duration(seconds: 5),
            mainButton: FlatButton(
              child: Text('Dismiss', style: TextStyle(color: Colors.amber)),
              onPressed: () {
                flush.dismiss(true);
              },
            ),
          )..show(context);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch : $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume : $message");
      },
    );
  }

  _deny(String id) {
    _firebaseService.redeemCoupon(couponID: id);
    Navigator.of(context).pop();
  }

  _redeem(String id) {
    _firebaseService.redeemCoupon(couponID: id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<T>(
        model: _model,
        child: ScopedModelDescendant<T>(
            child: Container(color: Colors.red), builder: widget._builder));
  }
}


class Message {
  
}
