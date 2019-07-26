import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../service_locator.dart';

class BaseView<T extends Model> extends StatefulWidget {
  final ScopedModelDescendantBuilder<T> _builder;
  final Function(T) onModelReady;

  /// Function will be called as soon as the widget is initialised.
  ///
  /// Callback will reive the model that was created and supplied to the ScopedModel

  BaseView({ScopedModelDescendantBuilder<T> builder, this.onModelReady})
      : _builder = builder;

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends Model> extends State<BaseView<T>> {
  T _model = locator<T>();
      final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();


  @override
  void initState() {
    if(widget.onModelReady != null) {
      widget.onModelReady(_model);
    }
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage : $message");
        showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
            );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch : $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume : $message");
      },
      
    );
     

  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<T>(
        model: _model,
        child: ScopedModelDescendant<T>(
            child: Container(color: Colors.red),
            builder: widget._builder));
  }
}


