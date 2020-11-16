import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:dealcircles_flutter/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PriceAlertView extends StatefulWidget {
  @override
  _PriceAlertView createState() => _PriceAlertView();
}

class _PriceAlertView extends State<PriceAlertView> {
  bool loading = false;
  List<PriceAlert> priceAlerts;

  @override
  void initState() {
    priceAlerts = [
      PriceAlert('gb Lufta Sleeper Playard, Mink, gb Lufta Sleeper Playard, Mink', '\$15.67', '\$13.00',
          'https://images-na.ssl-images-amazon.com/images/I/91w5gn1TEHL._SL1500_.jpg', 'link'),
      PriceAlert('gb Lufta Sleeper Playard, Mink, gb Lufta Sleeper Playard, Mink', '\$15.67', '\$13.00',
          'https://images-na.ssl-images-amazon.com/images/I/91w5gn1TEHL._SL1500_.jpg', 'link'),
      PriceAlert('gb Lufta Sleeper Playard, Mink, gb Lufta Sleeper Playard, Mink', '\$15.67', '\$13.00',
          'https://images-na.ssl-images-amazon.com/images/I/91w5gn1TEHL._SL1500_.jpg', 'link')
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: false,
        title: Text(
          'DealCircles',
          overflow: TextOverflow.visible,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        leading: Image.asset("assets/logo.png"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              showDialog(context: context,builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).primaryColor,
                        size: 56,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "To add an alert:\n\n"
                            "1. Find item on the Amazon app or website\n"
                            "2. Press share button and share with DealCircles App",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                );
              });
            }
          )
        ],
      ),
      body: _generateListview(context),
    );
  }

  Widget _generateListview(BuildContext context) {
    if (priceAlerts.length > 0) {
      return _appView(context);
    } else if (loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    } else {
      return createZeroAlertView();
    }
  }

  Widget _appView(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: priceAlerts.length,
      itemBuilder: (BuildContext context, int index) => createCard(index)
    );
  }

  Widget createCard(index) {
    return GestureDetector(
      onTap: () => showCardDetailDialog(index),
      child: Card(
        elevation: 4.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: _createRowTile(context, index),
        ),
      ),
    );
  }

  void showCardDetailDialog(index) {
    showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              priceAlerts[index].img,
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
            SizedBox(height: 10),
            Text(
              priceAlerts[index].name,
              style: TextStyle(fontSize: 24),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Current Price",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      Text("\$15.87",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  VerticalDivider(thickness: 2, color: Colors.black54,),
                  Column(
                    children: [
                      Text("Notify Price"),
                      Text("\$13.87")
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('See Deal',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () => ApiService.openLink(priceAlerts[index].link),
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Delete',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () {
                    showDeleteConfirmationDialog(context, index);
                  },
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Edit',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () => showNewPriceAlertDialog(index),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  void showNewPriceAlertDialog(index) {
    showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              priceAlerts[index].img,
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
            SizedBox(height: 10),
            Text(
              priceAlerts[index].name,
              style: TextStyle(fontSize: 24),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20),
            Text("Current Price",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Text(priceAlerts[index].price,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 20),
            Text("Notify when price at or below:"),
            SizedBox(height: 10),
            Container(
              width: 100,
              child: TextField(
                textAlign: TextAlign.center,
                maxLines: 1,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CurrencyTextInputFormatter(
                      decimalDigits: 2,
                      locale: 'en',
                      symbol: '\$'
                  )
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  hintText: priceAlerts[index].price
                )
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () => Navigator.pop(context),
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Save',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  void showDeleteConfirmationDialog(BuildContext context, index) {
    showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Delete?', style: TextStyle(fontSize: 24),),
            Image.network(
              priceAlerts[index].img,
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
            SizedBox(height: 10),
            Text(
              priceAlerts[index].name,
              style: TextStyle(fontSize: 24),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Current Price",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      Text("\$15.87",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  VerticalDivider(thickness: 2, color: Colors.black54,),
                  Column(
                    children: [
                      Text("Notify Price"),
                      Text("\$13.87")
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Go Back',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () => Navigator.pop(context),
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Delete',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _createRowTile(BuildContext context, int index) {
    PriceAlert priceAlert = priceAlerts[index];
    List<Widget> priceItems = [];
    priceItems.add(Text(
      priceAlert.price,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ));
    priceItems.add(Text(
      " | ${priceAlert.threshold}",
      overflow: TextOverflow.clip,
      style: TextStyle(color: Colors.black54, fontSize: 14),
    ));
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Row(
          children: <Widget>[
            Image.network(
              priceAlert.img,
              fit: BoxFit.contain,
              height: 60,
              width: 60,
            ),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(priceAlert.name,
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                  ),
                  Row(
                    children: priceItems,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createZeroAlertView() {
    return Center(
      heightFactor: 3,
      child: Text(
        "No alerts yet!\n\n"
            "To add an alert:\n"
            "1. Find item on the Amazon app or website\n"
            "2. Press share button and share with DealCircles",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}