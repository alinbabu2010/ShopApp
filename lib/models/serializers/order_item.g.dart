// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      json['id'] as String?,
      (json['amount'] as num).toDouble(),
      (json['products'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'products': instance.products,
      'dateTime': instance.dateTime.toIso8601String(),
    };
