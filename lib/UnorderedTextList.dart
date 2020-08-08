import 'package:flutter/material.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("\u2022 ", style: textStyle),
        Expanded(
          child: Text(text, style: textStyle,),
        ),
      ],
    );
  }
}