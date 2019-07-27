import 'package:flutter/material.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }

  // TODO according to DartDoc num.parse() includes both (double.parse and int.parse)
  return double.parse(s, (e) => null) != null ||
      int.parse(s, onError: (e) => null) != null;
}

class CharityInfo extends StatefulWidget {
  final BuildContext context;
  final UserHomeViewModel model;
  final User customer;
  final Charity charity;

  CharityInfo(
      {@required this.context,
      @required this.model,
      @required this.customer,
      @required this.charity});
  @override
  _CharityInfoState createState() => _CharityInfoState();
}

class _CharityInfoState extends State<CharityInfo> {
  int donatePoints;
  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }

      // TODO according to DartDoc num.parse() includes both (double.parse and int.parse)
      return double.parse(s, (e) => null) != null ||
          int.parse(s, onError: (e) => null) != null;
    }

    var currentCharity =
        widget.model.getCharityById(widget.model.charities, widget.charity.id);
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(height: 265.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey,
                        )
                      ],
                      border: Border.all(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Text(
                    "\$" + currentCharity.credits.toString(),
                    style: TextStyle(color: Colors.blue),
                  ),
                ))
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(currentCharity.imageUrl),
                fit: BoxFit.fill,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        )
      ],
    );

    final bottomContentText = Column(
      children: <Widget>[
        Text(
          currentCharity.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0),
        RichText(
          text: TextSpan(
            text: currentCharity.name,
            style: TextStyle(fontSize: 15, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: ' helps a lot of',
                  style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(
                  text: ' people around .....',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
    onDonate(String value, BuildContext context) async {
      print('donate');
      bool result = await widget.model.onDonate(currentCharity.id, widget.customer.id, int.parse(value));
      if(result){
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Donate to ' +
                currentCharity.name +
                ' successfully with $value Credits'),
            action: SnackBarAction(label: 'OK', onPressed: () {})));
      }else{
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Donate to ' +
                currentCharity.name +
                ' Failed with $value Credits'),
            action: SnackBarAction(label: 'OK', onPressed: () {})));
      }
    }

    final donateButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Number of credits ?'),
                      content: TextFormField(
                        controller: _inputController,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                            hintText: "credits",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
//                        onSaved: (input) => _username = input,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () =>
                              Navigator.pop(context, _inputController.text),
                        )
                      ],
                    )).then((returnVal) {
              if (returnVal != null) {
                print('return Val not null');
                if (!isNumeric(returnVal)) {
                  print('return Val not an Number');
                } else {
                  onDonate(returnVal, context);
                }
              }
            });
          },
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Text("DONATE THEM", style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, donateButton],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          topContent,
          Divider(
            color: Colors.blue,
          ),
          bottomContent
        ],
      ),
    );
  }
}
