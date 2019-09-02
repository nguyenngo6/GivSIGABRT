import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'custom_shape_clipper.dart';
class CustomerHomeViewPage extends StatefulWidget {
  @override
  _CustomerHomeViewPageState createState() => _CustomerHomeViewPageState();
}
class _CustomerHomeViewPageState extends State<CustomerHomeViewPage> {
  final preferredSize = new Size.fromHeight(160.0);
  Color firstColor = Color(0xFF3F51B5);
  Color secondColor = Color(0xFF9C27B0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 3),
            child: ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [secondColor, firstColor],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.only(top: 30),
                          icon: Icon(Icons.sort),
                          onPressed: null,
                          color: Colors.white,
                          iconSize: 28.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20, top: 15),
                                child: Text(
                                  'abc',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  'abc',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          flex: 2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                  width: 290,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 90, left: 40.0, bottom: 360),
                  child: Container(
                    height: 270,
                    child: Stack(
                      children: <Widget>[
                        Image.network("https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395__340.jpg",fit: BoxFit.fill,),
                        Column(
                          children: <Widget>[
                            Expanded(
                              flex:5,
                              child: Container(
                                padding: EdgeInsets.only(top: 20,left: 10),
                                child: Text("Put Some text here",style:TextStyle(fontSize: 20, color: Colors.white),),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.only(bottom: 10),
                                child: FlatButton(
                                  child: Text('Get Now',style:TextStyle(fontSize: 15, color: Colors.black)),
                                  onPressed: null,
                                  disabledColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
              Container(
                  width: 290,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                      top: 90,left: 20,right: 20, bottom: 360),
                  child: Container(
                    height: 270,
                   child: Stack(
                     children: <Widget>[
                       Image.network("https://cdn.pixabay.com/photo/2016/02/19/10/00/food-1209007__340.jpg",fit: BoxFit.fill,),
                       Column(
                         children: <Widget>[
                           Expanded(
                             flex:5,
                             child: Container(
                               padding: EdgeInsets.only(top: 20,left: 10),
                               child: Text("Put Some text here",style:TextStyle(fontSize: 20, color: Colors.white),),
                             ),
                           ),
                           Expanded(
                             flex: 3,
                             child: Container(
                               margin: EdgeInsets.all(10),
                               padding: EdgeInsets.only(bottom: 10),
                               child: FlatButton(
                                 child: Text('Get Now',style:TextStyle(fontSize: 15, color: Colors.black)),
                                 onPressed: null,
                                 disabledColor: Colors.white,
                               ),
                             ),
                           )
                         ],
                       )
                     ],
                   ),
                  )),
              Container(
                  width: 290,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                      top: 90,right:40 ,  bottom: 360),
                  child: Container(
                    height: 270,
                    child: Stack(
                      children: <Widget>[
                        Image.network("https://www.foodiesfeed.com/wp-content/uploads/2019/07/blueberry-cheesecake-with-poppyseed-600x400.jpg",fit: BoxFit.fill,),
                        Column(
                          children: <Widget>[
                            Expanded(
                              flex:5,
                              child: Container(
                                padding: EdgeInsets.only(top: 20,left: 10),
                                child: Text("Put Some text here",style:TextStyle(fontSize: 20, color: Colors.white),),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.only(bottom: 10),
                                child: FlatButton(
                                  child: Text('Get Now',style:TextStyle(fontSize: 15, color: Colors.black)),
                                  onPressed: null,
                                  disabledColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 255),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 6,
                        child: Container(
                            padding: EdgeInsets.only(left: 35),
                            child: Text("Categories",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),))),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: FlatButton(
                          child: Text("View all >"),
                          onPressed: null,
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 100,
                          height: 70,
                          child: Image.asset('assets/logo.png'),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Grocery',
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 100,
                          height: 70,
                          child: Image.asset('assets/logo.png'),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Grocery',
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(left: 20),
                          width: 100,
                          height: 70,
                          child: Image.asset('assets/logo.png'),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Grocery',
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 385),
            child: Column(
              children: <Widget>[
                Row(
                      children: <Widget>[
                        Expanded(
                            flex: 6,
                            child: Container(
                                padding: EdgeInsets.only(left: 35,top:5),
                                child: Text("Coupon List",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),))),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(right: 10,top: 5),
                            child: FlatButton(
                              child: Text("View all >"),
                              onPressed: null,
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        )
                      ],
                    ),
                Container(
                  height:180 ,
                  padding: EdgeInsets.only(left: 28,right: 28),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Container(
                        height:120,
                        child: Card(
                          elevation: 15.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child:Container(
                                        margin: EdgeInsets.all(10),
                                        height: 90,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image.network('https://chinesenewyear.imgix.net/assets/images/food/chinese-new-year-food-feast.jpg?q=50&w=1280&h=720&fit=crop&auto=format',
                                            fit: BoxFit.fill,),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 6,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.0),
                                              topRight: Radius.circular(2.0),
                                              bottomLeft: Radius.circular(2.0),
                                              bottomRight: Radius.circular(2.0)),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text("name"),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text("name"),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text("name"),
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 15.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child:Container(
                                      margin: EdgeInsets.all( 10),
                                      height: 90,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.network('https://chinesenewyear.imgix.net/assets/images/food/chinese-new-year-food-feast.jpg?q=50&w=1280&h=720&fit=crop&auto=format',
                                          fit: BoxFit.fill,),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(2.0),
                                            topRight: Radius.circular(2.0),
                                            bottomLeft: Radius.circular(2.0),
                                            bottomRight: Radius.circular(2.0)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text("name"),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text("name"),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text("name"),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
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
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
        onTap: null,
      ),
    );
  }
}







ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Container(
                        height:120,
                        child: Card(
                          elevation: 15.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child:Container(
                                        margin: EdgeInsets.all(10),
                                        height: 90,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image.network('https://chinesenewyear.imgix.net/assets/images/food/chinese-new-year-food-feast.jpg?q=50&w=1280&h=720&fit=crop&auto=format',
                                            fit: BoxFit.fill,),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 6,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2.0),
                                              topRight: Radius.circular(2.0),
                                              bottomLeft: Radius.circular(2.0),
                                              bottomRight: Radius.circular(2.0)),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text("name"),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text("name"),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text("name"),
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  ),


