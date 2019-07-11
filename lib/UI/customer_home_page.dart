import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/sign_in_page.dart';

enum WidgetMarker { listOfMerchants, listOfCoupons }

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  CollectionReference usersReference = Firestore.instance.collection("users");
  CollectionReference couponsReference =
      Firestore.instance.collection("coupons");
  String chosenMerchantId;
  WidgetMarker selectedWidgetMarker = WidgetMarker.listOfMerchants;
  TextEditingController editingController = TextEditingController();
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        setState(() {
          selectedWidgetMarker = WidgetMarker.listOfMerchants;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: _selectedIndex == 0
                ? Text('Home')
                : _selectedIndex == 1 ? Text('Charity') : Text('History')),
        actions: <Widget>[
          Center(
            child: Text(
              "CREDIT",
              style: optionStyle,
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: usersReference.document(widget.user.uid).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData) {
                return Center(
                    child: Text(snapshot.data.data['credits'].toString(),
                        style:
                            TextStyle(color: Colors.red[800], fontSize: 30)));
              }
            },
          ),
          IconButton(icon: Icon(Icons.credit_card)),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: new Text("Toan "),
              accountEmail: new Text("toan.do2806@icloud."),
              currentAccountPicture: GestureDetector(
                onTap: () => print("avatar tap"),
                child: CircleAvatar(
                  backgroundImage: new NetworkImage(
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
              trailing: IconButton(icon: Icon(Icons.edit), onPressed: null),
            ),
            ListTile(
              title: Text("Link2"),
              trailing:
                  IconButton(icon: Icon(Icons.arrow_left), onPressed: null),
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
      ),
      body: getBodyWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Charity'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

//function return list of coupons
  getCoupons(String uid) {
//    List<DocumentSnapshot> couponIDs = snapshot.data.documents;
    return StreamBuilder<QuerySnapshot>(
      stream:
          usersReference.document(uid).collection('ownedCoupons').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, rowNumber) {
              return Container(
                  height: 200.0,
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: InkWell(
                            onTap: () => {},
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: this
                                  .couponsReference
                                  .document(snapshot
                                      .data.documents[rowNumber].documentID)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snap) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch, // add this
                                    children: <Widget>[
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                          ),
                                          child: Image.network(
                                              snap.data.data['imageUrl'],
                                              // width: 300,
                                              fit: BoxFit.fill),
                                        ),
                                        flex: 8,
                                      ),
                                      Expanded(
                                        child: Center(
                                            child: Text(
                                                snap.data.data['description'])),
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ))));
            });
      },
    );
  }

//function return list of merchants
  getMerchants(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> merchants = snapshot.data.documents;
    return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, rowNumber) {
          return Container(
              height: 200.0,
              padding: EdgeInsets.all(10.0),
              child: Container(
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: InkWell(
                        onTap: () => setState(() {
                              selectedWidgetMarker = WidgetMarker.listOfCoupons;
                              chosenMerchantId =
                                  merchants[rowNumber].documentID;
                            }),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch, // add this
                          children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                child: Image.network(
                                    merchants[rowNumber].data['imageUrl'],
                                    // width: 300,
                                    fit: BoxFit.fill),
                              ),
                              flex: 8,
                            ),
                            Expanded(
                              child: Center(
                                  child: Text(
                                      merchants[rowNumber].data['username'])),
                              flex: 2,
                            ),
                          ],
                        ),
                      ))));
        });
  }

//for test
  getMerchantsSize(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("count:");
    print(snapshot.data.documents.length);
    return snapshot.data.documents.length;
  }

//Widget return list of merchants - (Home View)
  Widget getListOfMerchantsWidget() {
    print("getListOfMerchantsWidget function ==>>");
    return Column(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: editingController,
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: usersReference.where("level", isEqualTo: 2).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text("no documents");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading..');
              } else {
                return SizedBox(
                  child: getMerchants(snapshot),
                );
              }
            },
          ),
          flex: 9,
        ),
      ],
    );
  }

//widget return list of Coupons of any merchant
  Widget getListOfCouponsWidget(String uid) {
    print("getListOfCouponsWidget function ==>>");
    return Column(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: editingController,
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: getCoupons(uid),
          flex: 9,
        ),
//        Expanded(
//          child: StreamBuilder<QuerySnapshot>(
//            stream: this.snapshots,
//            builder:
//                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//              if (snapshot.hasError) {
//                return Text('Error: ${snapshot.error}');
//              } else if (!snapshot.hasData) {
//                return Text("no documents");
//              } else if (snapshot.connectionState == ConnectionState.waiting) {
//                return Text('Loading..');
//              } else {
//                return SizedBox(
//                  child: getCoupons(snapshot),
//                );
//              }
//            },
//          ),
//          flex: 9,
//        ),
      ],
    );
  }

//switch body widget function
  Widget getBodyWidget() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.listOfMerchants:
        return getListOfMerchantsWidget();
      case WidgetMarker.listOfCoupons:
        return getListOfCouponsWidget(this.chosenMerchantId);
    }

    return getListOfMerchantsWidget();
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
