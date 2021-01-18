import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';

class PriceAlertProductDialog extends StatelessWidget {
  final PriceAlert priceAlert;
  final bool newAlert;

  final TextEditingController textEditingController = new TextEditingController();

  PriceAlertProductDialog(this.priceAlert, this.newAlert, [String threshold]) {
    textEditingController.text = threshold;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
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
            maxLines: 2,
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
                      decimalDigits: 0,
                      locale: 'en',
                      symbol: '\$'
                  )
                ],
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme
                          .of(context)
                          .primaryColor),
                    ),
                    hintText: priceAlert.price // TODO
                )
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text('Cancel',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () => Navigator.pop(context, false),
        ),
        if (!newAlert)
          FlatButton(
            child: Text('Delete',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) {
                return PriceAlertDeleteConfirmationDialog(priceAlert);
              }).then((value) => Navigator.pop(context, value));
            },
          ),
        FlatButton(
          child: Text('Save',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () => Navigator.pop(context, int.parse(textEditingController.text.substring(1))),
        ),
        if (!newAlert)
          FlatButton(
            child: Text('See Item',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.pop(context, "link"),
          ),
      ],
    );
  }
}