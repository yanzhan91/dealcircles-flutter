import 'package:dealcircles_flutter/price_alerts_view/price_alert_type.dart';

class PriceAlert {
  PriceAlertType type;
  String text;
  String price;
  String threshold;
  String img;
  String link;

  PriceAlert(this.type, this.text, this.price, this.threshold, this.img, this.link);

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return PriceAlert(json['type'], json['text'], json['price'], json['threshold'], json['img'], json['link']);
  }
}