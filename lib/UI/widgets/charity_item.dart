import 'package:flutter/material.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/user.dart';

import 'charity_info.dart';

class CharityItem extends StatelessWidget {
  final User customer;
  final Charity charity;

  CharityItem({@required this.customer, @required this.charity});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200.0,
        padding: EdgeInsets.all(10.0),
        child: Container(
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(8.0))),
                child: InkWell(
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>CharityInfo(customer: customer, charity: charity))),
//                    print('infor tap tap');
//                    return CharityInfo(customer: customer, charity: charity);
//                  },
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
                          child: Image.network(charity.imageUrl,
                              // width: 300,
                              fit: BoxFit.fill),
                        ),
                        flex: 8,
                      ),
                      Expanded(
                        child:
                        Center(child: Text(charity.name)),
                        flex: 2,
                      ),
                    ],
                  ),
                ))));
  }
}
