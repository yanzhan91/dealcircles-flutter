import 'package:dealcircles_flutter/price_alerts_view/price_alert_type.dart';

class PriceAlert {
  int id;
  PriceAlertType alertType;
  String name;
  String price;
  String threshold;
  String img;
  String link;

  PriceAlert(this.alertType, this.name, this.price, this.threshold, this.img, this.link);

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return PriceAlert(json['type'], json['name'], json['price'], json['threshold'], json['img'], json['link']);
  }
}