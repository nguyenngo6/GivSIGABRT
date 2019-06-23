import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giver_app/UI/customer_home_page.dart';
import 'package:giver_app/UI/home_page.dart';
import 'package:giver_app/UI/merchant_home_page.dart';
import 'package:giver_app/UI/sign_up_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Provide an email';
                }
              },
              style: style,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Email",
                border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
              onSaved: (input) => _email = input,
            ),
            TextFormField(
              validator: (input) {
                if(input.length < 6){
                  return 'Longer password please';
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Password",
                border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
              onSaved: (input) => _password = input,
              obscureText: true,
            ),
            RaisedButton(
              onPressed: signIn,
              child: Text('Sign in'),
              
            ),
            RaisedButton(
              onPressed: signUp,
              child: Text('Sign up'),
            ),
          ],
        )
      ),
    );
  }
  Future <void> signIn() async {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      try {
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        FirebaseUser user =  await firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
        
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(user: user, firebaseAuth: firebaseAuth)));          
      } catch (e) {
        return AlertDialog(
          title: Text('error'),
        );
      }
    }
  }
  
  void signUp() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}
