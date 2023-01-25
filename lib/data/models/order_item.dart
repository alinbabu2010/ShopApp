import 'package:json_annotation/json_annotation.dart';
import 'package:shop_app/data/models/cart_item.dart';

part 'serializers/order_item.g.dart';

@JsonSerializable()
class OrderItem {
  String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
