import 'package:dealcircles_flutter/deals_detail/deal_content.dart';
import 'package:dealcircles_flutter/models/Deal.dart';
import 'package:dealcircles_flutter/models/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class DealDetails extends StatelessWidget {
  final Deal deal;

  DealDetails(this.deal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: DealContent(deal),
    );
  }

  Widget _createAppBar(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width >= Constants.screenMedium) {
      return null;
    } else {
      return AppBar(
        actions: <Widget>[
          if (!kIsWeb)
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                String message = "${deal.name} - " +
                    "${deal.discount}% Off\n${deal.link}\n\n" +
                    "Find more deals on DealCircles App\nhttps://www.dealcircles.com";
                Share.share(message,
                    subject: "Look what I found on DealCircles app!");
              },
            ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      );
    }
  }
}
