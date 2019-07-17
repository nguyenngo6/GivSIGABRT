
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
            accountName: Text("Toan "),
            accountEmail: Text("toan.do2806@icloud."),
            currentAccountPicture: GestureDetector(
              onTap: () => print("avatar tap"),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://profilepicturesdp.com/wp-content/uploads/2018/06/cute-baby-wallpaper-for-whatsapp-dp-11.jpg"),
              ),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://previews.123rf.com/images/wmitrmatr/wmitrmatr1408/wmitrmatr140800310/30747109-beautiful-paddy-with-nice-background.jpg"))),
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
