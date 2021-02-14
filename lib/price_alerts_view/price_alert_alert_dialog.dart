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
      title: Text(
        priceAlert.alertType == PriceAlertType.BRAND_OR_STORE ?
        "Notify when deals of\nthis brand are posted" :
        "Notify when deals with\nthese keywords are posted",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   priceAlert.alertType == PriceAlertType.BRAND_OR_STORE ?
          //   "Notify when deals of\nthis brand are posted" :
          //   "Notify when deals with\nthese keywords are posted",
          //   textAlign: TextAlign.center,
          // ),
          // SizedBox(height: 10),
          if (priceAlert.alertType == PriceAlertType.KEYWORD)
            Text(
              priceAlert.name,
              style: TextStyle(fontSize: 24),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (priceAlert.alertType != PriceAlertType.KEYWORD)
            Container(
              width: 100,
              height: 100,
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
        ],
      ),
      // contentPadding: EdgeInsets.zero,
      // insetPadding: EdgeInsets.zero,
      // buttonPadding: EdgeInsets.zero,
      // contentPadding: EdgeInsets.zero,
      // actionsPadding: EdgeInsets.symmetric(horizontal: 0.0),
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