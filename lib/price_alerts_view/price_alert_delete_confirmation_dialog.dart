import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:flutter/material.dart';

class PriceAlertDeleteConfirmationDialog extends StatelessWidget {
  final PriceAlert priceAlert;

  const PriceAlertDeleteConfirmationDialog(this.priceAlert);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Delete this price alert?",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Image.network(
            priceAlert.img,
            fit: BoxFit.contain,
            height: 200,
            width: 200,
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
          child: Text('Cancel',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () => Navigator.pop(context, false),
        ),
        FlatButton(
          child: Text('Delete',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}