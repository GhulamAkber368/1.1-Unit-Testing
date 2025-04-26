class ProductOrder {
  String? name;
  double? price;
  String? user;

  ProductOrder({this.name, this.price, this.user});

  ProductOrder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['user'] = user;
    return data;
  }
}
