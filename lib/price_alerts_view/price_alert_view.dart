import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceAlertView extends StatelessWidget {
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
      ),
      // body: _generateListview(context),
    );
  }
}