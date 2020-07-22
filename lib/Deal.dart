class Deal {
  String name;
  List description;
  String id;
  String brand;
  String originalPrice;
  String salePrice;
  int discount;
  String img;
  List images;
  String store;
  String link;
  DateTime createDate;
  bool valid;

  Deal(this.id, this.name, this.description, this.brand, this.originalPrice, this.salePrice, this.discount, this.img,
      this.images, this.store, this.link, this.createDate, this.valid);

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(json['id'], json['name'], json['description'] ?? [], json['brand'], json['original'], json['new'], json['discount'].toInt(),
        json['img'], json['images'] ?? [], json['store'], json['link'], DateTime.parse(json['created_date']), json['valid']);
  }
}
