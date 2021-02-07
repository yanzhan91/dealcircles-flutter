import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_dialog_response.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_dialog_response_type.dart';
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
          if (priceAlert.alertType == PriceAlertType.KEYWORD)
            Container(
              width: 60,
              height: 60,
              child:
                Icon(
                  Icons.bookmark_outline,
                  color: Theme.of(context).primaryColor,
                  size: 60,
                ),
            ),
          if (priceAlert.alertType != PriceAlertType.KEYWORD)
            Container(
              width: 120,
              height: 120,
              child:
                priceAlert.alertType == PriceAlertType.BRAND_OR_STORE ?
                  Image.asset(
                    priceAlert.img,
                    fit: BoxFit.contain,
                  ) :
                  Image.network(
                    priceAlert.img,
                    fit: BoxFit.contain,
                  ),
            ),
          SizedBox(height: 10),
          Text(
            priceAlert.alertType == PriceAlertType.BRAND_OR_STORE ?
            "Notify when deals of\nthis brand are posted" :
            "Notify when deals with\nthese keywords are posted",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            priceAlert.name,
            style: TextStyle(fontSize: 24),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: () => Navigator.pop(context,
              PriceAlertDialogResponse(PriceAlertDialogResponseType.NULL, null)),
        ),
        FlatButton(
          child: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: () => Navigator.pop(context,
              PriceAlertDialogResponse(PriceAlertDialogResponseType.DELETE, null))
        ),
      ],
    );
  }
}