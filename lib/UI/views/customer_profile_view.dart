import 'package:flutter/material.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/customer_profile_view_model.dart';
import 'package:giver_app/enum/view_state.dart';
import 'base_view.dart';
import 'customer_home_view.dart';

class CustomerProfileView extends StatelessWidget {
  final User user;
//  List<User> customers;

  CustomerProfileView({@required this.user});

  @override
  Widget build(BuildContext context) {
    return BaseView<CustomerProfileViewModel>(
        builder: (context, child, model) => Scaffold(
              appBar: AppBar(
                leading: FlatButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CustomerHomeView(user: user))),
                    child: Icon(Icons.backspace)),
                title: Text("title"),
                actions: <Widget>[
                  Center(
                    child: Text(
                      "CREDIT",
                    ),
                  ),
                  IconButton(icon: Icon(Icons.credit_card)),
                ],
              ),
              body: _getBodyUi(context, model),
            ));
  }

  Widget _getBodyUi(BuildContext context, CustomerProfileViewModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return _getLoadingUi(context);
      case ViewState.NoDataAvailable:
        return _noDataUi(context, model);
      case ViewState.Error:
        return _errorUi(context, model);
      case ViewState.DataFetched:
      default:
        return _getCustomerProfile(model);
    }
  }

  Widget _getCustomerProfile(CustomerProfileViewModel model) {
//    customers = model.customers;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 4.0,
        ),
        ListTile(
          leading: Text("UID:"),
          title: Text(user.id),
          trailing: Icon(Icons.edit),
        ),
        ListTile(
          leading: Text("1"),
          title: Image.network(user.imageUrl),
          trailing: Icon(Icons.edit),
        ),
        ListTile(
          leading: Text("2"),
          title: Text(user.username),
          trailing: Icon(Icons.edit),
        ),
        ListTile(
          leading: Text("3"),
          title: Text(user.email),
          trailing: Icon(Icons.edit),
        ),
        ListTile(
          leading: Text("4"),
          title: Text(user.phone),
          trailing: Icon(Icons.edit),
        ),
      ],
    );
//
//    return StreamBuilder<DocumentSnapshot>(
//      stream: Firestore.instance
//          .collection('users')
//          .document(this.uid)
//          .snapshots(),
//      builder:
//          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//        if (snapshot.hasError) {
//          return Text('Error: ${snapshot.error}');
//        }
//        if (snapshot.hasData) {
//          return Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                height: 4.0,
//              ),
//              ListTile(
//                leading: Text("1"),
//                title: Text(snapshot.data.data['username']),
//                trailing: Icon(Icons.edit),
//
//              ),
//              ListTile(
//                leading: Text("2"),
//                title: Text(snapshot.data.data['email']),
//                trailing: Icon(Icons.edit),
//
//              ),
//
//
//
//            ],
//          );
//        }
//      },
//    );
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

  Widget _noDataUi(BuildContext context, CustomerProfileViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, CustomerProfileViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  Widget _getCenteredViewMessage(
      BuildContext context, String message, CustomerProfileViewModel model,
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
}
