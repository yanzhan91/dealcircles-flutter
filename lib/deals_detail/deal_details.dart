import 'dart:math';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dealcircles_flutter/models/Deal.dart';
import 'package:dealcircles_flutter/deals_detail/UnorderedTextList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/api_service.dart';

class DealDetails extends StatefulWidget {
  final Deal deal;

  DealDetails(this.deal);

  @override
  State<StatefulWidget> createState() => _DealDetailsState();
}

class _DealDetailsState extends State<DealDetails> {

  int _current = 0;

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
                  "${widget.deal.discount}% Off\n${widget.deal.link}\n\n" +
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: openLink,
                    child: CarouselSlider.builder(
                      itemCount: max(widget.deal.images.length, 1),
                      itemBuilder: (BuildContext context, int itemIndex) => Container(
                        child: Image.network(
                          widget.deal.images.length > 0 ? widget.deal.images[itemIndex] : widget.deal.img,
                          fit: BoxFit.contain,
                        ),
                      ),
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.width,
                        autoPlay: false,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, right: 15),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${widget.deal.discount}%",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              "OFF",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.deal.images.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.deal.images.map((url) {
                  int index = widget.deal.images.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Theme.of(context).primaryColor
                          : Color.fromRGBO(0, 0, 0, 0.25),
                    ),
                  );
                }).toList(),
              ),
            Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.deal.brand,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            widget.deal.salePrice,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Theme.of(context).primaryColor),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                              Icon(
                                Icons.star_border,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          )
                        ],
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
                      if (widget.deal.descriptions != null && widget.deal.descriptions.length > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(widget.deal.descriptions.length == 0 ? "Description" : "Features",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (widget.deal.descriptions != null && widget.deal.descriptions.length == 1)
                        Text(
                          widget.deal.descriptions[0],
                          style: TextStyle(fontSize: 16),
                        ),
                      if (widget.deal.descriptions != null && widget.deal.descriptions.length > 1)
                        UnorderedTextList(
                          widget.deal.descriptions,
                          TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: EdgeInsets.only(top: 15, right: 15),
                      child: widget.deal.valid
                        ? Text(
                            fetchDaysAgo(widget.deal),
                            style:
                                TextStyle(fontSize: 12, color: Colors.black),
                          )
                        : Text(
                            "Expired",
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String fetchDaysAgo(Deal deal) {
    DateTime now = DateTime.now().toUtc();
    DateTime date = deal.createDate;
    int days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;

    switch (days) {
      case 0:
        return "Today";
      case 1:
        return "1 day ago";
      default:
        return "$days days ago";
    }
  }

  void openLink() async {
    ApiService.addClicks(widget.deal);
    String link = widget.deal.link;
    if (await canLaunch(link)) {
      await launch(link, forceSafariVC: false);
    } else {
      print('Could not launch ' + link);
    }
  }
}