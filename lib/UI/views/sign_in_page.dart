import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giver_app/UI/views/home_view.dart';
import 'package:giver_app/UI/views/block_home_page.dart';

import 'package:giver_app/UI/views/sign_up_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/enum/view_state.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _inputController = TextEditingController();
  String _errorMessage = '';
  var _state;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
//    print('validator');
//    print(EmailValidator.validate('toando0612@gmail.com') == true);
    return BusyOverlay(
        show: this._state == ViewState.Busy,
        child: Scaffold(
          appBar: AppBar(title: Center(child: Text('Giver App')),),
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget> [Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Provide an email';
                              } else {
                                return null;
                              }
                            },
//                style: style,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            onSaved: (input) => _email = input,
                          ),
                          new Container(height: 5.0),
                          TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Provide a password';
                              } else if (input.length < 6) {
                                return 'Password must have at least 6 characters';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            onSaved: (input) => _password = input,
                            obscureText: true,
                          ),
                          Container(
                              height: 5.0,
                              child: Text(
                                _errorMessage,
                                style: TextStyle(color: Colors.red),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: signIn,
                                child: Text('Sign in'),
                              ),
                              Container(
                                width: 50.0,
                              ),
                              RaisedButton(
                                onPressed: signUp,
                                child: Text('Sign up'),
                              ),
                            ],
                          ),
                          FlatButton(
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () { showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Please enter your email'),
                                  content: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    validator: validateEmail,
                                    controller: _inputController,
                                    decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                                        hintText: "Email",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0))),
//                        onSaved: (input) => _username = input,
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () =>
                                          Navigator.pop(context, _inputController.text),
                                    )
                                  ],
                                )).then((returnVal) {
                              if (returnVal != null) {
                                print('return Val not null');
                                FirebaseAuth.instance.sendPasswordResetEmail(email: _inputController.text);
                                print('email sent to' + _inputController.text);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Email sent to ' +
                                        _inputController.text),
                                    action: SnackBarAction(label: 'OK', onPressed: () {})));
                              }
                            });},
                          ),
                        ],
                      )))],
            ),
          ),
        ));
  }

  Future<void> signIn() async {
    setState(() {
      _state = ViewState.Busy;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        FirebaseUser user = await firebaseAuth
            .signInWithEmailAndPassword(email: _email, password: _password)
            .catchError((error) {
          setState(() {
            _errorMessage = error.code.toString();
          });
        }).whenComplete(() {
          setState(() {
            _state = ViewState.DataFetched;
          });
        });
        if (user.isEmailVerified) {
          
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeView(user: user)));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BlockHomePage(user: user)));
        }
      } catch (e) {
        return AlertDialog(
          title: Text('error'),
        );
      }
    }
  }

  void signUp() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
  
}
