part of '../product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      price: double.parse(json['price'].toString()),
      imageUrl: json['imageUrl'] as String,
      isFavorite: json['isFavorite'].toString().parseBool(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price.toString(),
      'imageUrl': instance.imageUrl,
      'isFavorite': instance.isFavorite.toString(),
    };
