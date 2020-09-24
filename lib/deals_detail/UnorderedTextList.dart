import 'dart:ui';

import 'package:dealcircles_flutter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UnorderedTextList extends StatelessWidget {
  UnorderedTextList(this.texts, this.textStyle);
  final List texts;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedTextListItem(text, textStyle));
      // Add space between items
      widgetList.add(SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedTextListItem extends StatelessWidget {
  UnorderedTextListItem(this.text, this.textStyle);
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    Widget textWidget;
    if (text.startsWith("Apply promo code")) {
      textWidget = GestureDetector(
        onTap: () {
          String code = new RegExp(r'[A-Z0-9]{6,}').stringMatch(text);
          if (code != null) {
            Clipboard.setData(ClipboardData(text: code));
            final snackBar = SnackBar(
              content: Text('Promo Code Copied!'),
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              action: SnackBarAction(
                label: 'Ok',
                textColor: Colors.white,
                onPressed: () {},
              ),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        child: Text(text,
          style: textStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dashed),
        ),
      );
    } else if (text.startsWith("Don't have prime membership?")) {
      textWidget = GestureDetector(
        onTap: () {
          openLink("https://amzn.to/32TFcSm");
        },
        child: Text(text,
          style: textStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dashed),
        ),
      );
    } else {
      textWidget = Text(text, style: textStyle,);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("\u2022 ", style: textStyle),
        Expanded(
          child: textWidget,
        ),
      ],
    );
  }

  void openLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link, forceSafariVC: false);
    }
  }
}