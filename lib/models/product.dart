import 'package:json_annotation/json_annotation.dart';
import 'package:shop_app/utils/extension.dart';

part 'serializers/product.g.dart';

@JsonSerializable()
class Product {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite = false;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
