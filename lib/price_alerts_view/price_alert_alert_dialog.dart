import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceAlertAlertDialog extends StatelessWidget {
  final PriceAlert priceAlert;

  const PriceAlertAlertDialog(this.priceAlert);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (priceAlert.type == PriceAlertType.KEYWORD)
            Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.notifications_active_outlined,
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
          SizedBox(height: 10),
          Text(
            priceAlert.type == PriceAlertType.BRAND_OR_STORE ?
            "Notify when deals of\nthis brand are posted" :
            "Notify when deals with\nthis keyword are posted",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            priceAlert.text,
            style: TextStyle(fontSize: 24),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: () => Navigator.pop(context, false),
        ),
        FlatButton(
          child: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: () => Navigator.pop(context, true)
        ),
      ],
    );
  }
}