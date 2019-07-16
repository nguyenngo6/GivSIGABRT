import 'package:flutter/material.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/customer_profile_view_model.dart';
import 'package:giver_app/enum/view_state.dart';
import 'base_view.dart';
import 'customer_home_view.dart';

class CustomerProfileView extends StatefulWidget {
  final User user;

  CustomerProfileView({@required this.user});


  @override
  _CustomerProfileViewState createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  var thisState = ViewState.Idle;
  @override
  Widget build(BuildContext context) {
    return BaseView<CustomerProfileViewModel>(
        builder: (context, child, model) => BusyOverlay(
          show: model.state == ViewState.Busy,
          child: Scaffold(
                  appBar: AppBar(
                    leading: FlatButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomerHomeView(user: widget.user))),
                        child: Icon(Icons.backspace)),
                    title: Text("title"),
                    actions: <Widget>[
                      Center(
                        child: Text(
                          "CREDIT",
                        ),
                      ),
                      Center(
                          child: Text(
                        widget.user.points.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      )),
                      Center(child: IconButton(icon: Icon(Icons.credit_card))),
                    ],
                  ),
                  body: _getBodyUi(context, model),
                ),
        ),
        );
  }

  Widget _getBodyUi(BuildContext context, CustomerProfileViewModel model) {
    switch (model.state) {
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
    var image = Image.network(widget.user.imageUrl);
    User currentUser = model.getCurrentUser(model.customers, widget.user.id);
    return Column(
                children: <Widget>[
                  Container(
                    height: 40.0,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.imageUrl),
                    radius: 120,
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: model.state == ViewState.EditUsername
                        ? TextFormField(
                            onFieldSubmitted: (input)=>onSubmit(input, model),
                            initialValue: currentUser.username,
                          )
                        : Text(currentUser.username,
                            style:
                                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    trailing: FlatButton(
                        onPressed: () => model.setState(ViewState.EditUsername),
                        child: Icon(Icons.edit)),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(currentUser.email),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(currentUser.phone),
                    trailing: FlatButton(onPressed: null, child: Icon(Icons.edit)),
                  ),
                ],
    );
  }

  Widget _noDataUi(BuildContext context, CustomerProfileViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, CustomerProfileViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  onSubmit(String input, CustomerProfileViewModel model)async{
    await model.onUsernameEdited(input, widget.user.id);

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
