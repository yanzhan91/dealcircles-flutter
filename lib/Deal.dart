class Deal {
  String name;
  String id;
  String brand;
  String originalPrice;
  String salePrice;
  double discount;
  String img;
  String store;
  String link;

  Deal(this.id, this.name, this.brand, this.originalPrice, this.salePrice, this.discount, this.img,
      this.store, this.link);

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(json['id'], json['name'], json['brand'], json['original'], json['new'], json['discount'].toDouble(),
        json['img'], json['store'], json['link']);
  }
}
