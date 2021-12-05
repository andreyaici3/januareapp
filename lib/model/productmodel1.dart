// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel1> productModel1FromJson(String str) =>
    List<ProductModel1>.from(
        json.decode(str).map((x) => ProductModel1.fromJson(x)));

String productModel1ToJson(List<ProductModel1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel1 {
  ProductModel1({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
  });

  String id;
  String name;
  String qty;
  String price;

  factory ProductModel1.fromJson(Map<String, dynamic> json) => ProductModel1(
        id: json["id"],
        name: json["name"],
        qty: json["qty"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "qty": qty,
        "price": price,
      };
}
