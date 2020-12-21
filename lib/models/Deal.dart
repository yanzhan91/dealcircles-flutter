class Deal {
  String name;
  List descriptions;
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
  Set themes;
  String promoCode;
  double ratings;
  int numReviews;
  String extra;

  Deal(this.id, this.name, this.descriptions, this.brand, this.originalPrice, this.salePrice, this.discount, this.img,
      this.images, this.store, this.link, this.createDate, this.valid, this.themes, this.promoCode, this.ratings, this.numReviews, this.extra);

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(json['id'], json['name'], json['descriptions'] ?? [], json['brand'], json['original'], json['new'], json['discount'].toInt(),
      json['img'], json['images'] ?? [], json['store'], json['link'], DateTime.parse(json['created_date']), json['valid'], Set.of(json['themes'] ?? []),
      json['promo_code'], json['ratings'], json['num_reviews'], json['extra']
    );
  }
}
