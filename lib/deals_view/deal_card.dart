import 'package:dealcircles_flutter/models/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/Deal.dart';
import '../services/api_service.dart';
import '../deals_detail/deal_details.dart';

class DealsCard extends StatelessWidget {
  final Deal deal;

  const DealsCard(this.deal);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ApiService.addClicks(deal);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DealDetails(deal)));
      },
      child: Stack(
        children: <Widget>[
          Card(
            elevation: 4.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: makeListTile(context, deal),
            ),
          ),
          _addNewFlag(context, deal)
        ],
      ),
    );
  }

  Container makeListTile(BuildContext context, Deal deal) {
    List<Widget> priceItems = [];
    priceItems.add(Text(
      deal.salePrice,
      style: TextStyle(
        color: deal.valid ? Theme.of(context).primaryColor : Colors.black54,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ));
    priceItems.add(Text(
      " | ${deal.discount}% Off" + (deal.valid ? "" : " | "),
      overflow: TextOverflow.clip,
      style: TextStyle(color: Colors.black54, fontSize: 14),
    ));
    if (!deal.valid) {
      priceItems.add(Text(
        "Expired",
        overflow: TextOverflow.clip,
        style: TextStyle(color: Colors.red, fontSize: 14),
      ));
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: kIsWeb && MediaQuery.of(context).size.width >= Constants.screenMedium
            ? _createBoxTile(context, priceItems)
            : _createRowTile(context, priceItems),
      ),
    );
  }

  Widget _createRowTile(BuildContext context, List<Widget> priceItems) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.network(
              deal.images.length > 0 ? deal.images[0] : deal.img,
              fit: BoxFit.contain,
              height: 80,
              width: 80,
            ),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    deal.brand,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(deal.name,
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                      maxLines: 2,
                      // TODO ellipsis not working on web
                      overflow:
                          kIsWeb ? TextOverflow.clip : TextOverflow.ellipsis),
                  Row(
                    children: priceItems,
                  )
                ],
              ),
            ),
          ],
        ),
        _setThemeIcons(context),
      ],
    );
  }

  Widget _createBoxTile(BuildContext context, List<Widget> priceItems) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.network(
              deal.images.length > 0 ? deal.images[0] : deal.img,
              fit: BoxFit.contain,
              height: 100,
              width: 100,
            ),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    deal.brand,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(deal.name,
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.clip),
                  Row(
                    children: priceItems,
                  )
                ],
              ),
            ),
          ],
        ),
        _setThemeIcons(context),
      ],
    );
  }

  Widget _addNewFlag(BuildContext context, Deal deal) {
    DateTime now = DateTime.now();
    DateTime posted = deal.createDate.toLocal();
    if (now.year == posted.year &&
        now.month == posted.month &&
        now.day == posted.day) {
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.fiber_new,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    } else {
      return new Container();
    }
  }

  Widget _setThemeIcons(BuildContext context) {
    return GestureDetector(
      onTap: () => _showThemeIconAlert(context),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 60,
          height: 40,
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (deal.themes.contains("TopBrand"))
                  Icon(
                    Icons.whatshot,
                    size: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                if (deal.themes.contains("FourStars"))
                  Icon(
                    Icons.star,
                    size: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                if (deal.themes.contains("DealOfTheDay"))
                  Icon(
                    Icons.attach_money,
                    size: 14,
                    color: Theme.of(context).primaryColor,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeIconAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 152,
              child: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.whatshot,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Top Brand',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '4+ Stars',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.attach_money,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Deal of the Day',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  if (!kIsWeb) // TODO positioned overflow not working on web
                    Positioned(
                      top: -90,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/icon_120.jpg",
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(40, 50, 40, 0),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
