import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/coupon.dart';
import 'package:giver_app/UI/sign_in_page.dart';
import 'package:giver_app/UI/add_coupon_page.dart';
import 'package:giver_app/UI/edit_coupon_page.dart';

class MerchantHomePage extends StatefulWidget {
  const MerchantHomePage({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _MerchantHomePageState createState() => _MerchantHomePageState();
}

class _MerchantHomePageState extends State<MerchantHomePage> {
  TextEditingController editingController = TextEditingController();
  int _selectedIndex = 0;
  PageController _pageController;
  @override
  void initState(){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),onPressed: AddCoupons),
        ],
//        bottom: PreferredSize(
//            preferredSize: const Size.fromHeight(45.0),
////            child: Row(
////              mainAxisAlignment: MainAxisAlignment.center,
////              crossAxisAlignment: CrossAxisAlignment.center,
////              children: <Widget>[
////                Tooltip(
////                  child: RaisedButton(
////                    onPressed: () {},
////                    child:
////                        const Text('Merchants', style: TextStyle(fontSize: 20)),
////                  ),
////                  message: "Find Merchant",
////                  verticalOffset: 30,
////                ),
////                const SizedBox(
////                  width: 50.0,
////                ),
////                Tooltip(
////                  child: RaisedButton(
////                    onPressed: () {},
////                    child:
////                        const Text('Charity', style: TextStyle(fontSize: 20)),
////                  ),
////                  message: "Donate",
////                  verticalOffset: 30,
////                ),
////              ],
////            )
//        ),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('users').document(widget.user.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot userData){
                  return Text(userData.data.data['username']);
              },),
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
              title: Text("Link1"),
              trailing: IconButton(icon: Icon(Icons.cancel), onPressed: null),
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
      body: customBodyWidget(),

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
    );
  }

  AddCoupons(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AddCoupon(user: widget.user)));
  }

  getCoupons(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new ListTile(
              title: new Text(doc.documentID),
            ))
        .toList();
  }

  getMerchantsName(){

  }

  getMerchantsSize(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("count:");
    print(snapshot.data.documents.length);
    return snapshot.data.documents.length;
  }

  Widget customBodyWidget(){
    switch (_selectedIndex){
      case 0:
        return getHomeView();
      case 2:
        return getHistoryView();
    }
  }

  Widget getHomeView(){
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
            stream: Firestore.instance
                .collection('users')
                .document(widget.user.uid)
                .collection("ownedCoupons")
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text("no documents");
              } else if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Text('Loading..');
              } else {
                return new Coupon(user: widget.user);
              }
            },
          ),
          flex: 9,
        ),
      ],
    );
  }

  Widget getHistoryView(){
    return Text("this is history");
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
