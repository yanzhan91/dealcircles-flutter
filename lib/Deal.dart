class Deal {
  String name;
  String brand;
  double originalPrice;
  double salePrice;
  double discount;
  String img;
  String store;
  String link;

  Deal(this.name, this.brand, this.originalPrice, this.salePrice, this.discount, this.img,
      this.store, this.link);

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(json['name'], json['brand'], json['original'].toDouble(), json['new'].toDouble(), json['discount'].toDouble(),
        json['img'], json['store'], json['link']);
  }
}
