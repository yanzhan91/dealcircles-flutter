class PriceAlert {
  String name;
  String price;
  String threshold;
  String img;
  String link;
  // List descriptions;
  // String id;
  // String brand;
  // int discount;
  // List images;
  // String store;
  // DateTime createDate;
  // bool valid;
  // Set themes;
  // String promoCode;
  // double ratings;
  // int numReviews;
  //

  PriceAlert(this.name, this.price, this.threshold, this.img, this.link);

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return PriceAlert(json['name'], json['price'], json['threshold'], json['img'], json['link']);
  }

  // Deal(this.id, this.name, this.descriptions, this.brand, this.originalPrice, this.salePrice, this.discount, this.img,
  //     this.images, this.store, this.link, this.createDate, this.valid, this.themes, this.promoCode, this.ratings, this.numReviews);
  //
  // factory Deal.fromJson(Map<String, dynamic> json) {
  //   return Deal(json['id'], json['name'], json['descriptions'] ?? [], json['brand'], json['original'], json['new'], json['discount'].toInt(),
  //       json['img'], json['images'] ?? [], json['store'], json['link'], DateTime.parse(json['created_date']), json['valid'], Set.of(json['themes'] ?? []),
  //       json['promo_code'], json['ratings'], json['num_reviews']
  //   );
  // }
}