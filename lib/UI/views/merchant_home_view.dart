import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/Views/sign_in_page.dart';
import 'package:giver_app/UI/shared/ui_reducers.dart';
import 'package:giver_app/UI/views/merchant_profile_view.dart';
import 'package:giver_app/UI/widgets/coupon_list.dart';
import 'package:giver_app/UI/widgets/merchant_image.dart';
import 'package:giver_app/UI/widgets/merchant_info.dart';

import 'package:giver_app/UI/widgets/simple_toolbar.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';

import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/merchant_profile_view_model.dart';
import 'package:giver_app/UI/views/base_view.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/UI/widgets/coupon_item.dart';
import 'package:giver_app/services/merchant_notification_hander.dart';

import 'add_coupon_page.dart';
import 'edit_coupon_page.dart';
import 'merchant_edit_info_view.dart';

class MerchantHomeView extends StatefulWidget {
  const MerchantHomeView({@required this.user});

  final User user;

  @override
  _MerchantHomeViewState createState() => _MerchantHomeViewState();
}

class _MerchantHomeViewState extends State<MerchantHomeView> {
  TextEditingController editingController = TextEditingController();
  int _selectedIndex = 0;
  PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void navigationTapped(int index) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  addCoupons() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => AddCoupon(user: widget.user)));
  }

  Widget customBodyWidget(UserHomeViewModel model) {
    switch (_selectedIndex) {
      case 0:
        return getHomeView(model);
      case 2:
        return getHistoryView(model);
    }
  }

  Widget getHomeView(UserHomeViewModel model) {
    List<Coupon> couponList =
    model.getCouponsByMerchantId(model.coupons, widget.user.id);
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
                String title = coupon.description.toString();
                String pointx = coupon.points.toString();
                return Container(
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    child: Container(
//                        child: Card(
//                          shape: RoundedRectangleBorder(
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(8.0))),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch, // add this
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(1.0),
                                        topRight: Radius.circular(1.0),
                                        bottomLeft: Radius.circular(1.0),
                                        bottomRight: Radius.circular(1.0)
                                    ),

                                    child: Container(
//                                          margin: EdgeInsets.only(right: 3),
                                      height: 140,
                                      color: Colors.lightBlue[200],
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Description: " + title),
                                          Text('${coupon.id}')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 140,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),

                                    ),
                                    child: Image.network('http://www.kfcrecipe.com/wp-content/uploads/2018/11/KFC-fried-chicken-recipe-1-1.jpg',fit: BoxFit.cover,),
                                  ),

                                  flex: 3,
                                )
                              ],
                            ),
                            flex: 8,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed:(){
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                            EditCoupon(user: widget.user,coupon: coupon,)));
                                  },
                                  child: Text('Edit'),
                                ),
                                RaisedButton(
                                  onPressed: (){
                                    _deleteCoupon(coupon,widget.user);
                                  },
                                  child: Text('Delete'),
                                )
                              ],
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
//                        )
                    )
                );
              }),
          flex: 9,
        )
      ],
    );
  }
  _deleteCoupon(Coupon coupon,User user){
    Firestore.instance.collection('coupons').document(coupon.id).delete();

//    Firestore.instance.collection('user').document(widget.user.id).collection('ownedCoupons').document(coupon.id).delete();
  }

  Widget getHistoryView(UserHomeViewModel model) {
    List<Coupon> couponList =
    model.getCouponsByMerchantId(model.coupons, widget.user.id);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: couponList.length,
              itemBuilder:( context, rowNumber){
                var coupon = couponList[rowNumber];
                if(coupon.isUsed == true){
                  String title = coupon.description.toString();
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(1.0),
                                topRight: Radius.circular(1.0),
                                bottomLeft: Radius.circular(1.0),
                                bottomRight: Radius.circular(1.0)
                            ),

                            child: Container(
//                                          margin: EdgeInsets.only(right: 3),
                              height: 140,
                              color: Colors.lightBlue[200],
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("Description: " + title),
//                            Text('${coupon.id}')
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 140,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                            ),
                            child: Image.network('http://www.kfcrecipe.com/wp-content/uploads/2018/11/KFC-fried-chicken-recipe-1-1.jpg',fit: BoxFit.cover,),
                          ),

                          flex: 3,
                        )
                      ],
                    ),
                  );
                } else{
                  return null;
                }

              }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
   
    return BaseView<UserHomeViewModel>(
        builder: (context, child, model) => Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Home'),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: addCoupons,
              )
            ],
          ),
          drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(widget.user.username),
                  accountEmail: new Text(widget.user.email),
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
                    title: Text("Edit"),
                    trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MerchantUpdateInfoView(
                                      merchant: model.getCurrentUser(
                                          model.merchants, widget.user.id),
                                    ))))),
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
          body: customBodyWidget(model),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                title: Text('Camera'),
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
}