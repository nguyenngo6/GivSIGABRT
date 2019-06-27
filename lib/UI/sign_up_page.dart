import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _username;
  String _email;
  String _phone;
  String _password;
  String _confirm;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(),
      body: new Container(
          padding: new EdgeInsets.all(10.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: Image.asset('assets/profile.png'),
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide an username';
                      }
                    },
                    autofocus: true,
//                style: style,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    onSaved: (input) => _username = input,
                  ),
                  Container(
                    height: 5.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide an email';
                      }
                    },
                    autofocus: true,
//                style: style,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    onSaved: (input) => _email = input,
                  ),
                  Container(
                    height: 5.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide an phone';
                      }
                    },
                    autofocus: true,
//                style: style,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                        hintText: "Phone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    onSaved: (input) => _phone = input,
                  ),
                  Container(
                    height: 5.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide a password';
                      } else if (input.length < 6) {
                        return 'Password must have at least 6 characters';
                      }
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    onSaved: (input) => _password = input,
                    obscureText: true,
                  ),
                  Container(
                    height: 5.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide a confirm password';
                      } else if (input.length < 6) {
                        return 'Password must have at least 6 characters';
                      }
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                        hintText: "confirm password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    onSaved: (input) => _confirm = input,
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
                        onPressed: () {},
                      ),
                    ],
                  ),


                ],
              ))),
    );
  }

  Future<void> signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        user.sendEmailVerification();
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
