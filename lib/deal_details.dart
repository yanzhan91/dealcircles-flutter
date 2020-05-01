import 'dart:ui';

import 'package:dealcircles_flutter/Deal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_service.dart';

class DealDetails extends StatefulWidget {
  final Deal deal;

  DealDetails(this.deal);

  @override
  State<StatefulWidget> createState() => _DealDetailsState();
}

class _DealDetailsState extends State<DealDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              String message = "${widget.deal.name} - " +
                  "${widget.deal.discount}% Off\n${widget.deal.link}\n" +
                      "View more deals on DealCircles App";
              Share.share(message, subject: "Look what I found!");
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          widget.deal.img,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15, right: 15),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              "${widget.deal.discount.toInt()}%",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.deal.brand,
                        style: TextStyle(fontSize: 24, color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.deal.name,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.deal.originalPrice,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        widget.deal.salePrice,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          onPressed: openLink,
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "See Deal at ${widget.deal.store}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void openLink() async {
    ApiService.addClicks(widget.deal);
    String link = widget.deal.link;
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      print('Could not launch ' + link);
    }
  }
}
