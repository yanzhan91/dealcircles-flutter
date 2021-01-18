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

  static PriceAlert _deserialize(int id, PriceAlertType alertType, String name, String price, String threshold, String img, String link) {
    PriceAlert priceAlert = PriceAlert(alertType, name, price, threshold, img, link);
    priceAlert.id = id;
    return priceAlert;
  }

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return _deserialize(json['id'] as int, getType(json['alerttype'].toString()), json['name'], json['price'], json['threshold'], json['img'], json['link']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'alertType': this.alertType.toString().split('.').last,
      'name': this.name,
      'price': this.price,
      'threshold': this.threshold,
      'img': this.img,
      'link': this.link
    };
  }

  static PriceAlertType getType(String s) {
    for (PriceAlertType alert in PriceAlertType.values) {
      if (alert.toString().split(".").last == s) {
        return alert;
      }
    }
    return PriceAlertType.UNKNOWN;
  }
}