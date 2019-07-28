import 'package:flutter/material.dart';
import 'package:giver_app/model/donation.dart';
import 'package:giver_app/scoped_model/customer_history_view_model.dart';
import 'donation_history_item.dart';

class DonationHistory extends StatelessWidget {
  final CustomerHistoryViewModel model;
  final String uid;
  DonationHistory({@required this.model, @required this.uid});

  @override
  Widget build(BuildContext context) {
    List<Donation> donations = model.donations;
    return ListView.builder(
        itemCount: donations.length,
        itemBuilder: (BuildContext context, rowNumber) {
          var donation = donations[rowNumber];
          print('time stamp:' + donation.time.toString());
          return DonationHistoryItem(
            charityName: model.getCharityNameById(
                model.charities, donation.charityId),
            donation: donation,
          );
        });
  }
}
