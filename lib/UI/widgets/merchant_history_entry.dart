import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/text_style.dart';

class MerchantHistoryEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('entry'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 190,
              child: Card(

                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                  margin: EdgeInsets.all(10.0),
                  elevation: 15.0,
//                color: Colors.cyanAccent,
//            height: 155,
//            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                  child: Column(
                    children: <Widget>[
                      //header
                      Container(
                        margin: EdgeInsets.only(bottom: 3,right: 10,top: 10),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "July 24 2019",
                          style: Style.couponHistoryTextStyle,
                        ),
                      ),
                      Divider(color: Colors.black,height: 15,),
                      //body
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              child: Text("STANDARD 50",
                                  style: Style.couponHistoryTextStyleBigger),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 10,left: 10,bottom: 5),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text("Description:",
                                      style: Style.couponHistoryTextStyle),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10,left: 20,bottom: 5),
                                ),
                                Container(
                                  child: Text("Get 50% off",
                                      style: Style.couponHistoryTextStyle),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10,left: 10,bottom: 5),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Points :",
                                    style: Style.couponHistoryTextStyle,
                                  ),
                                  margin: EdgeInsets.only(left: 20,bottom: 5),
                                ),Container(
                                  child: Text(
                                    "15 ",
                                    style: Style.couponHistoryTextStyle,
                                  ),
                                  margin: EdgeInsets.only(left: 10,bottom: 5),
                                ),
                              ],
                            ),
                            Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 20,bottom: 15,right: 10),
                                    child: Text("Used by:",
                                        style: Style.couponHistoryTextStyle)
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 15,right: 10),
                                  child: Text("toando2806@icloud.com",
                                      style: Style.couponHistoryTextStyle),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              height: 190,
              child: Card(

                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.all(10.0),
                  elevation: 15.0,
//                color: Colors.cyanAccent,
//            height: 155,
//            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                  child: Column(
                    children: <Widget>[
                      //header
                      Container(
                        margin: EdgeInsets.only(bottom: 3,right: 10,top: 10),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "July 24 2019",
                          style: Style.couponHistoryTextStyle,
                        ),
                      ),
                      Divider(color: Colors.black,height: 15,),
                      //body
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              child: Text("STANDARD 50",
                                  style: Style.couponHistoryTextStyleBigger),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 10,left: 10,bottom: 5),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text("Description:",
                                      style: Style.couponHistoryTextStyle),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10,left: 20,bottom: 5),
                                ),
                                Container(
                                  child: Text("Get 50% off",
                                      style: Style.couponHistoryTextStyle),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10,left: 10,bottom: 5),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Points :",
                                    style: Style.couponHistoryTextStyle,
                                  ),
                                  margin: EdgeInsets.only(left: 20,bottom: 5),
                                ),Container(
                                  child: Text(
                                    "15 ",
                                    style: Style.couponHistoryTextStyle,
                                  ),
                                  margin: EdgeInsets.only(left: 10,bottom: 5),
                                ),
                              ],
                            ),
                            Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 20,bottom: 15,right: 10),
                                    child: Text("Used by:",
                                        style: Style.couponHistoryTextStyle)
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 15,right: 10),
                                  child: Text("toando2806@icloud.com",
                                      style: Style.couponHistoryTextStyle),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              height: 190,
              child: Card(

                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.all(10.0),
                  elevation: 15.0,
//                color: Colors.cyanAccent,
//            height: 155,
//            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                  child: Column(
                    children: <Widget>[
                      //header
                      Container(
                        margin: EdgeInsets.only(bottom: 3,right: 10,top: 10),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "July 24 2019",
                          style: Style.couponHistoryTextStyle,
                        ),
                      ),
                      Divider(color: Colors.black,height: 15,),
                      //body
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              child: Text("STANDARD 50",
                                  style: Style.couponHistoryTextStyleBigger),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 10,left: 10,bottom: 5),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text("Description:",
                                      style: Style.couponHistoryTextStyle),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10,left: 20,bottom: 5),
                                ),
                                Container(
                                  child: Text("Get 50% off",
                                      style: Style.couponHistoryTextStyle),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10,left: 10,bottom: 5),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Points :",
                                    style: Style.couponHistoryTextStyle,
                                  ),
                                  margin: EdgeInsets.only(left: 20,bottom: 5),
                                ),Container(
                                  child: Text(
                                    "15 ",
                                    style: Style.couponHistoryTextStyle,
                                  ),
                                  margin: EdgeInsets.only(left: 10,bottom: 5),
                                ),
                              ],
                            ),
                            Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 20,bottom: 15,right: 10),
                                    child: Text("Used by:",
                                        style: Style.couponHistoryTextStyle)
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 15,right: 10),
                                  child: Text("toando2806@icloud.com",
                                      style: Style.couponHistoryTextStyle),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              height: 190,
              child: Card(

                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.all(10.0),
                  elevation: 15.0,
//                color: Colors.cyanAccent,
//            height: 155,
//            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                  child: Column(
                    children: <Widget>[
                      //header
                      Container(
                        margin: EdgeInsets.only(bottom: 3,right: 10,top: 10),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "July 24 2019",
                          style: Style.couponHistoryTextStyle,
                        ),
                      ),
                      Divider(color: Colors.black,height: 15,),
                      //body
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              child: Text("STANDARD 50",
                                  style: Style.couponHistoryTextStyleBigger),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 10,left: 10,bottom: 5),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text("Description:",
                                      style: Style.couponHistoryTextStyle),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10,left: 20,bottom: 5),
                                ),
                                Container(
                                  child: Text("Get 50% off",
                                      style: Style.couponHistoryTextStyle),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10,left: 10,bottom: 5),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Points :",
                                    style: Style.couponHistoryTextStyle,
                                  ),
                                  margin: EdgeInsets.only(left: 20,bottom: 5),
                                ),Container(
                                  child: Text(
                                    "15 ",
                                    style: Style.couponHistoryTextStyle,
                                  ),
                                  margin: EdgeInsets.only(left: 10,bottom: 5),
                                ),
                              ],
                            ),
                            Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 20,bottom: 15,right: 10),
                                    child: Text("Used by:",
                                        style: Style.couponHistoryTextStyle)
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 15,right: 10),
                                  child: Text("toando2806@icloud.com",
                                      style: Style.couponHistoryTextStyle),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}