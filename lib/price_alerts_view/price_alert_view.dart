import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_add_view.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_alert_dialog.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_product_dialog.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_type.dart';
import 'package:dealcircles_flutter/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      PriceAlert(PriceAlertType.URL, 'gb Lufta Sleeper Playard, Mink, gb Lufta Sleeper Playard, Mink', '\$15.67', '\$13',
          'https://images-na.ssl-images-amazon.com/images/I/91w5gn1TEHL._SL1500_.jpg', 'link'),
      PriceAlert(PriceAlertType.BRAND_OR_STORE, 'Nike', null, null,
          'https://i.pinimg.com/originals/33/e6/3d/33e63d5adb0da6b303a83901c8e8463a.png', 'null'),
      PriceAlert(PriceAlertType.KEYWORD, 'Ipad', null, null, null, 'null')
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
            onPressed: () => _getNewPriceAlert(context),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Text(
            "Create a price alert to be notified\nabout deals for you.",
            // "Create a price alert\n\nWe will notify you when we find deals of products on your list",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20,),
          _generateListview(context),
        ],
      )

    );
  }

  Future _getNewPriceAlert(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PriceAlertAddView()));

    if (result != null) {
      setState(() {
        priceAlerts.add(result);
      });
    }
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
    priceAlerts.sort((a,b) => b.type.toString().compareTo(a.type.toString()));
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
      if (priceAlerts[index].type == PriceAlertType.URL) {
        return PriceAlertProductDialog(priceAlerts[index], false,
            priceAlerts[index].threshold);
      } else {
        return PriceAlertAlertDialog(priceAlerts[index]);
      }
    }).then((value) {
      if (value is bool) {
        if (value == true) {
          setState(() {
            priceAlerts.removeAt(index);
          });
        }
      } else if (value is String) {
        setState(() {
          priceAlerts[index].threshold = value;
        });
      } else {
        ApiService.openLink(priceAlerts[index].link);
      }
    });
  }

  Widget _createRowTile(BuildContext context, int index) {
    PriceAlert priceAlert = priceAlerts[index];
    List<Widget> priceItems = [];
    if (priceAlert.type == PriceAlertType.URL) {
      priceItems.add(Text(
        priceAlert.price,
        style: TextStyle(
          color: Theme
              .of(context)
              .primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ));
    }
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
            if (priceAlert.type == PriceAlertType.KEYWORD)
              Container(
                width: 60,
                height: 60,
                child: Icon(
                  Icons.bookmark_outline,
                  color: Theme.of(context).primaryColor,
                  size: 40,
                ),
              ),
            if (priceAlert.type != PriceAlertType.KEYWORD)
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
                  Text(priceAlert.text,
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                  ),
                  if (priceAlerts[index].type == PriceAlertType.URL)
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
        "Create a price alert to be notified about deals you care about.",
        // "Create a price alert\n\nWe will notify you when we find deals of products on your list",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}