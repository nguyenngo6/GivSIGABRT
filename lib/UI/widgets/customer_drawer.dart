
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/user.dart';
import '../views/customer_profile_view.dart';
import '../views/sign_in_page.dart';

class CustomerDrawer extends StatefulWidget {
  final User customer;
  CustomerDrawer({@required this.customer});
  @override
  _MerChanrDrawerState createState() => _MerChanrDrawerState();
}

class _MerChanrDrawerState extends State<CustomerDrawer> {
  @override
  Widget build(BuildContext context) {

    displayProfileEditor(User user) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerProfileView(user: user)));
    }

    signOut() {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
    }


    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.customer.username, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0,)),
            accountEmail: Text(widget.customer.email, style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic)),
            currentAccountPicture: GestureDetector(
              onTap: () => print("avatar tap"),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    widget.customer.imageUrl),
              ),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://images-na.ssl-images-amazon.com/images/I/81X4TID9IML._SL1500_.jpg"),
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(1.0), BlendMode.dstATop))),
          ),
          ListTile(
            title: Text("Edit Profile"),
            trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => displayProfileEditor(widget.customer)),
          ),
          ListTile(
            title: Text("Link2"),
            trailing: IconButton(icon: Icon(Icons.arrow_left), onPressed: null),
          ),
          ListTile(
            title: Text("Sign Out"),
            trailing: IconButton(
                tooltip: "Log out",
                icon: Icon(Icons.exit_to_app),
                onPressed: signOut),
          ),
        ],
      ),
    );
  }
}
