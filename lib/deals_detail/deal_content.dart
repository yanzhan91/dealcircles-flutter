import 'package:dealcircles_flutter/models/Deal.dart';
import 'package:dealcircles_flutter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'UnorderedTextList.dart';
import 'deal_carousel_slider.dart';

class DealContent extends StatefulWidget {
  final Deal deal;

  DealContent(this.deal);

  @override
  _DealContentState createState() => _DealContentState();
}

class _DealContentState extends State<DealContent> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _createContent(),
    );
  }

  Widget _createContent() {
    return Column(
      children: <Widget>[
        Center(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: _openLink,
                child: DealCarouselSlider(widget.deal.images, widget.deal.img),
              ),
              _createPercentOffWidget(context),
            ],
          ),
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
                      _createRatingStars(),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: _openLink,
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
    );
  }

  void _openLink() async {
    ApiService.addClicks(widget.deal);
    String link = widget.deal.link;
    if (await canLaunch(link)) {
      await launch(link, forceSafariVC: false);
    } else {
      print('Could not launch ' + link);
    }
  }

  Widget _createPercentOffWidget(BuildContext context) {
    return Align(
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
    );
  }

  Widget _createRatingStars() {
    return Row(
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
}