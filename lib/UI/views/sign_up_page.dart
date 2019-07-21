import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/enum/view_state.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _email;
  String _password;
  String _username;
  int _selected = 0;

  var _state;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _usernameController = TextEditingController();

  void onChanged(int value) {
    setState(() {
      _selected = value;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
        show: this._state == ViewState.Busy,
        child: Scaffold(
          appBar: new AppBar(),
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                    padding: new EdgeInsets.all(10.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RadioListTile(
                              value: 1,
                              title: new Text('Level 1'),
                              groupValue: _selected,
                              onChanged: (int value) {
                                onChanged(value);
                              },
                              activeColor: Colors.red,
                              subtitle: new Text('Customer'),
                            ),
                            RadioListTile(
                              value: 2,
                              title: new Text('Level 2'),
                              groupValue: _selected,
                              onChanged: (int value) {
                                onChanged(value);
                              },
                              activeColor: Colors.red,
                              subtitle: new Text('Merchant'),
                            ),
                            Container(
                              height: 4.0,
                            ),
                            TextFormField(
                              controller: _emailController,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Provide an email';
                                }
                              },
                              autofocus: true,
//                style: style,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 15.0),
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              onSaved: (input) => _email = input,
                            ),
                            Container(
                              height: 4.0,
                            ),
                            TextFormField(
                              controller: _usernameController,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Provide a username';
                                }
                              },
                              autofocus: true,
//                style: style,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 15.0),
                                  hintText: "Username",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              onSaved: (input) => _username = input,
                            ),
                            Container(
                              height: 4.0,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Provide a password';
                                } else if (input.length < 6) {
                                  return 'Password must have at least 6 characters';
                                }
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 15.0),
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              onSaved: (input) => _password = input,
                              obscureText: true,
                            ),
                            Container(
                              height: 4.0,
                            ),
                            TextFormField(
                              controller: _confirmController,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Provide a confirm password';
                                } else if (input.length < 6) {
                                  return 'Password must have at least 6 characters';
                                } else if (input != _passwordController.text) {
                                  return 'Confirm password did not match!';
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 15.0),
                                  hintText: "confirm password",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              obscureText: true,
                            ),
                            Container(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: signUp,
                                  child: Text('Sign up'),
                                ),
                                FlatButton(
                                  child: Text(
                                    'Have an account? Login !',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  onPressed: backLogin,
                                ),
                              ],
                            ),
                          ],
                        )))
              ],
            ),
          ),
        ));
  }

  Future<void> signUp() async {
    setState(() {
      _state == ViewState.Busy;
    });
    if (_formKey.currentState.validate()) {
//      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));// bug when not using inside Scafford
      _formKey.currentState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        user.sendEmailVerification();
        print("send email to-->");
        print(_emailController.text);
        Firestore.instance.runTransaction((Transaction transaction) async {
          CollectionReference reference =
              Firestore.instance.collection('users');

          await reference.document(user.uid).setData(
              {"email": _email, "username": _username, "level": _selected});
          DocumentReference docRef =
              Firestore.instance.collection('users').document(user.uid);
          if (_selected == 1) {
            docRef
                .collection('usedCoupons')
                .document()
                .setData({"customerID": user.uid});
          } else {
            docRef
                .collection('ownedCoupons')
                .document()
                .setData({"merchantID": user.uid});
          }
        });
        setState(() {
          _state == ViewState.DataFetched;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
      } catch (e) {
        print(e.messaage);
      }
    }
  }

  void backLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
