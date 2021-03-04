import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_delete_confirmation_dialog.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_dialog_response.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_dialog_response_type.dart';
import 'package:flutter/material.dart';

class PriceAlertProductDialog extends StatelessWidget {
  final PriceAlert priceAlert;
  final bool newAlert;

  final TextEditingController textEditingController =
      new TextEditingController();

  PriceAlertProductDialog(this.priceAlert, this.newAlert, [String threshold]) {
    if (threshold != null) {
      textEditingController.text = "\$" + threshold;
    } else {
      textEditingController.text = "\$" + priceAlert.price.split(".").first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      content: SingleChildScrollView(
        reverse: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              priceAlert.img,
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
            SizedBox(height: 10),
            Text(
              priceAlert.name,
              style: TextStyle(fontSize: 20),
              maxLines: 4,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20),
            Text("Current Price"),
            Text(priceAlert.price),
            SizedBox(height: 20),
            Text("Notify when price is at or below:"),
            SizedBox(height: 10),
            Container(
              width: 100,
              child: TextField(
                  controller: textEditingController,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                        decimalDigits: 0, locale: 'en', symbol: '\$')
                  ],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    // hintText: "\$" + priceAlert.price.split(".").first,
                  )),
            ),
          ],
        ),
      ),
      // actionsOverflowDirection: VerticalDirection.up,
      actions: [
        FlatButton(
          child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
          textColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pop(
              context,
              PriceAlertDialogResponse(
                  PriceAlertDialogResponseType.NULL, null)),
        ),
        if (!newAlert)
          FlatButton(
            child:
                Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              showDialog<PriceAlertDialogResponse>(
                      context: context,
                      builder: (BuildContext context) {
                        return PriceAlertDeleteConfirmationDialog(priceAlert);
                      })
                  .then((PriceAlertDialogResponse value) =>
                      Navigator.pop(context, value));
            },
          ),
        FlatButton(
          child: Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          textColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pop(
              context,
              PriceAlertDialogResponse(
                  PriceAlertDialogResponseType.SAVE,
                  textEditingController.text
                      .replaceAll(new RegExp(r"[$,]"), ""))),
        ),
        if (!newAlert)
          FlatButton(
            child:
                Text('See Item', style: TextStyle(fontWeight: FontWeight.bold)),
            textColor: Theme.of(context).primaryColor,
            onPressed: () => Navigator.pop(
                context,
                PriceAlertDialogResponse(
                    PriceAlertDialogResponseType.LINK, null)),
          ),
      ],
    );
  }
}
