import 'package:flutter/material.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/user.dart';

class CharityInfo extends StatelessWidget {
  final User customer;
  final Charity charity;
  CharityInfo({@required this.customer, @required this.charity});
  @override
  Widget build(BuildContext context) {
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
                    "\$" + charity.credits.toString(),
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
                image: NetworkImage(charity.imageUrl),
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

    final bottomContentText = Column(children: <Widget>[
      Text(
        charity.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5.0),
      RichText(
        text: TextSpan(
          text: charity.name,
          style: TextStyle(fontSize: 15, color: Colors.black),
          children: <TextSpan>[
            TextSpan(text: ' helps a lot of', style: TextStyle(fontStyle: FontStyle.italic)),
            TextSpan(text: ' people around .....', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      )

    ],);
    final donateButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => print('donate tap tap'),
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child:
              Text("DONATE THEM", style: TextStyle(color: Colors.white)),
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
        children: <Widget>[topContent,Divider(color: Colors.blue,), bottomContent],
      ),
    );
  }
}
