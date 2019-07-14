import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/sign_in_page.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/customer_home_view_model.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/enum/view_state.dart';

import '../service_locator.dart';
import 'base_view.dart';
import 'customer_profile_view.dart';

enum WidgetMarker {
  listOfMerchants,
  listOfCoupons,
  charityOrganizations,
  history
}

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _CustomerHomeViewState createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  CollectionReference usersReference = Firestore.instance.collection("users");
  CollectionReference couponsReference =
      Firestore.instance.collection("coupons");
  String merchantId;
  WidgetMarker selectedWidget = WidgetMarker.listOfMerchants;
  TextEditingController editingController = TextEditingController();
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedIndex == 0
          ? selectedWidget = WidgetMarker.listOfMerchants
          : _selectedIndex == 1
              ? selectedWidget = WidgetMarker.charityOrganizations
              : selectedWidget = WidgetMarker.history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CustomerHomeViewModel>(
        builder: (context, child, model) => Scaffold(
              appBar: AppBar(
                title: Center(
                    child: _selectedIndex == 0
                        ? Text('Home')
                        : _selectedIndex == 1
                            ? Text('Charity')
                            : Text('History')),
                actions: <Widget>[
                  Center(
                    child: Text(
                      "CREDIT",
                      style: optionStyle,
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream:
                        usersReference.document(widget.user.uid).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        return Center(
                            child: Text(
                                snapshot.data.data['credits'].toString(),
                                style: TextStyle(
                                    color: Colors.red[800], fontSize: 30)));
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
                      trailing:
                          IconButton(icon: Icon(Icons.edit), onPressed: ()=>displayProfileEditor(widget.user.uid)),
                    ),
                    ListTile(
                      title: Text("Link2"),
                      trailing: IconButton(
                          icon: Icon(Icons.arrow_left), onPressed: null),
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
              body: _getBodyUi(context, model),
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
            ));
  }

//function return list of coupons
  getCoupons(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> couponIDs = snapshot.data.documents;
    return ListView.builder(
        itemCount: couponIDs.length,
        itemBuilder: (context, rowNumber) {
          return Container(
              height: 200.0,
              padding: EdgeInsets.all(10.0),
              child: Container(
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: InkWell(
                          onTap: () => {},
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: couponsReference
                                      .document(couponIDs[rowNumber].documentID)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          couponData) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .stretch, // add this
                                      children: <Widget>[
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0),
                                            ),
                                            child: Image.network(
                                                couponData
                                                    .data.data['imageUrl'],
                                                // width: 300,
                                                fit: BoxFit.fill),
                                          ),
                                          flex: 8,
                                        ),
                                        Expanded(
                                          child: Center(
                                              child: Text(couponData
                                                  .data.data['description'])),
                                          flex: 2,
                                        ),
                                      ],
                                    );
                                  }))))));
        });
  }

//Widget return list of merchants - (Home View)
  Widget getListOfMerchantsWidget(CustomerHomeViewModel model) {
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
          child: ListView.builder(
              itemCount: model.merchants.length,
              itemBuilder: (context, rowNumber) {
                var merchant = model.merchants[rowNumber];
                return Container(
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: InkWell(
                              onTap: () => this.setState(() {
                                    selectedWidget = WidgetMarker.listOfCoupons;
                                    merchantId = merchant.id;
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
                                      child: Image.network(merchant.imageUrl,
                                          // width: 300,
                                          fit: BoxFit.fill),
                                    ),
                                    flex: 8,
                                  ),
                                  Expanded(
                                    child:
                                        Center(child: Text(merchant.username)),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ))));
              }),
          flex: 9,
        ),
      ],
    );
  }

  Widget getListOfCouponsWidget(String uid,CustomerHomeViewModel model) {
    List<Coupon> couponList = model.getCouponsByMerchantId(model.coupons, merchantId);
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
          child: ListView.builder(
              itemCount: couponList.length,
              itemBuilder: (context, rowNumber) {
                var coupon = couponList[rowNumber];
                return Container(
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                            child: InkWell(
                              onTap: () => null,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch, // add this
                                children: <Widget>[
                                  Expanded(
                                    child: Text(coupon.description),
                                    flex: 8,
                                  ),
                                  Expanded(
                                    child:
                                    Center(child: Text(coupon.ownedBy)),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ))));
              }),
          flex: 9,
        ),
      ],
    );
  }

  Widget getListOfCharitiesWidget(CustomerHomeViewModel model) {
    print("getCharityOrganizations function ==>>");
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
          child: ListView.builder(
              itemCount: model.charities.length,
              itemBuilder: (context, rowNumber) {
                var charity = model.charities[rowNumber];
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
                                          charity.imageUrl,
                                          // width: 300,
                                          fit: BoxFit.fill),
                                    ),
                                    flex: 8,
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: Text(charity.name)),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ))));
              }),
          flex: 9,
        ),
      ],
    );
  }

//widget return list of Coupons of any merchant
//  Widget getListOfCouponsWidget() {
//    print("getListOfCouponsWidget function ==>>");
//    return Column(
//      children: <Widget>[
//        Expanded(
//          child: TextField(
//            controller: editingController,
//            decoration: InputDecoration(
//              labelText: "Search",
//              hintText: "Search",
//              prefixIcon: Icon(Icons.search),
//            ),
//          ),
//          flex: 1,
//        ),
//        Expanded(
//          child: StreamBuilder<QuerySnapshot>(
//            stream: usersReference
//                .document(this.merchantId)
//                .collection('ownedCoupons')
//                .snapshots(),
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
//      ],
//    );
//  }

//switch body widget function
  Widget _getBodyUi(BuildContext context, CustomerHomeViewModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return _getLoadingUi(context);
      case ViewState.NoDataAvailable:
        return _noDataUi(context, model);
      case ViewState.Error:
        return _errorUi(context, model);
      case ViewState.DataFetched:
        return selectedWidget == WidgetMarker.listOfMerchants
            ? getListOfMerchantsWidget(model)
            : selectedWidget == WidgetMarker.charityOrganizations
                ? getListOfCharitiesWidget(model):selectedWidget == WidgetMarker.listOfCoupons
            ? getListOfCouponsWidget(this.merchantId, model)
                : getHistoryWidget(model);
      default:
        return getListOfMerchantsWidget(model);
    }
  }

  getHistoryWidget(CustomerHomeViewModel model) {}

  signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  Widget _getLoadingUi(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        Text('Fetching data ...')
      ],
    ));
  }

  Widget _noDataUi(BuildContext context, CustomerHomeViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, CustomerHomeViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  Widget _getCenteredViewMessage(
      BuildContext context, String message, CustomerHomeViewModel model,
      {bool error = false}) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                error
                    ? Icon(
                        // WWrap in gesture detector and call you refresh future here
                        Icons.refresh,
                        color: Colors.white,
                        size: 45.0,
                      )
                    : Container()
              ],
            )));
  }

  displayProfileEditor(String uid){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CustomerProfileView(uid: uid)));
  }
}
