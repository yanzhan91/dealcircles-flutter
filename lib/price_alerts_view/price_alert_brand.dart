import 'package:dealcircles_flutter/price_alerts_view/price_alert_type.dart';

class PriceAlertBrand {
  String name;
  String img;

  PriceAlertBrand(this.name, this.img);

  factory PriceAlertBrand.fromJson(Map<String, dynamic> json) {
    return PriceAlertBrand(json['name'], json['link']);
  }
}