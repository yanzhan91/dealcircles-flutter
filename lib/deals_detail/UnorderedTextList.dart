import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UnorderedTextList extends StatelessWidget {
  UnorderedTextList(this.texts, this.textStyle);
  final List texts;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      widgetList.add(UnorderedTextListItem(text, textStyle));
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
    if (text.contains(RegExp(r'\(http.*\)'))) {
      String link = text.substring(
          text.indexOf('\(') + 1, text.lastIndexOf('\)'));
      textWidget = GestureDetector(
        onTap: () {
          openLink(link);
        },
        child: Text(text.substring(0, text.indexOf('\(') - 1).trim(),
          style: textStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid),
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