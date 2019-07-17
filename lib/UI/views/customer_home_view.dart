import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/Views/sign_in_page.dart';
import 'package:giver_app/UI/views/merchant_profile_view.dart';
import 'package:giver_app/UI/views/qr_scan_view.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';
import 'base_view.dart';
import 'customer_profile_view.dart';

enum WidgetMarker { listOfMerchants, charityOrganizations, history }

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({@required this.user});
  final User user;
  @override
  _CustomerHomeViewState createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  TextEditingController editingController = TextEditingController();
  WidgetMarker selectedWidget = WidgetMarker.listOfMerchants;
  String _selectedTittle = 'Home';
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
      _selectedIndex == 0
          ? _selectedTittle = 'Home'
          : _selectedIndex == 1
              ? _selectedTittle = 'Charity'
              : _selectedTittle = 'History';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<UserHomeViewModel>(
        builder: (context, child, model) => BusyOverlay(
          show: model.state == ViewState.Busy,
          child: Scaffold(
                appBar: _getAppBar(_selectedTittle, widget.user.points),
                drawer: _getDrawer(),
                body: _getBodyUi(context, model),
                bottomNavigationBar: _getBottomBar(),
              ),
        ));
  }

  Widget _getAppBar(String title, int points) {
    return AppBar(
      title: Center(child: Text(title)),
      actions: <Widget>[
        Center(child: Text('CREDIT')),
        Center(
            child: Text(
          points.toString(),
          style: TextStyle(color: Colors.red, fontSize: 25),
        )),
        FlatButton(
          onPressed: ()=> print('clmm thang Nguyen Ngo'),
          child: Icon(Icons.camera_alt),
        )
      ],
    );
  }

  Widget _getDrawer() {
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
                onPressed: () => displayProfileEditor(widget.user)),
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

  Widget _getBottomBar() {
    return BottomNavigationBar(
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
    );
  }

//Widget return list of merchants - (Home View)
  Widget getListOfMerchantsWidget(UserHomeViewModel model) {
    var merchants = model.merchants;
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
              itemCount: merchants.length,
              itemBuilder: (context, rowNumber) {
                var merchant = merchants[rowNumber];
                return Container(
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: InkWell(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MerchantProfileView(
                                          merchant: merchant,
                                          customer: widget.user))),
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

  Widget getCharityListWidget(User user, UserHomeViewModel model) {
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
          child: BusyOverlay(
              show: model.state == ViewState.Busy,
              child: Scaffold(
                body: Text('this is charityList'),
              )),
          flex: 9,
        ),
      ],
    );
  }

//switch body widget function
  Widget _getBodyUi(BuildContext context, UserHomeViewModel model) {
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
                ? getCharityListWidget(widget.user, model)
                : Navigator.pushReplacement(
                    context, MaterialPageRoute(
                      builder: (context) => QrScanView(customer: widget.user,)));
      default:
        return getListOfMerchantsWidget(model);
    }
  }

  getHistoryWidget(UserHomeViewModel model) {
    return Text('history');
  }

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

  Widget _noDataUi(BuildContext context, UserHomeViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, UserHomeViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  Widget _getCenteredViewMessage(
      BuildContext context, String message, UserHomeViewModel model,
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

  displayProfileEditor(User user) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerProfileView(user: user)));
  }
}