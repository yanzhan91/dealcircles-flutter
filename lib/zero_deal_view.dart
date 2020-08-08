import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZeroDealView extends StatelessWidget {
  final VoidCallback loadDeals;

  const ZeroDealView(this.loadDeals);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.remove_circle_outline,
              size: 60,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 20),
            Text(
              "No Results Found",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Check out latest deals"),
              ),
              textColor: Colors.white,
              onPressed: () {
                loadDeals();
              },
            ),
          ],
        ),
      ),
    );
  }
}