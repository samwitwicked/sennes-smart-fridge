// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      amount: json['amount'] as int,
      size: json['size'] as String,
      imageUrl: json['imageUrl'] as String,
      thumbnail: json['thumbnail'] as String,
      manufacturerNote: json['manufacturerNote'] as String,
      changed: (json['changed'] as List)
          ?.map((e) => e == null ? null : DateTime.parse(e as String))
          ?.toList(),
      website: json['website'] as String,
      brand: json['brand'] as String,
      dataComplete: json['dataComplete'] as bool,
      ingredients: json['ingredients'] as List,
      nutriments: json['nutriments'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'barcode': instance.barcode,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'thumbnail': instance.thumbnail,
      'size': instance.size,
      'manufacturerNote': instance.manufacturerNote,
      'website': instance.website,
      'brand': instance.brand,
      'amount': instance.amount,
      'changed': instance.changed?.map((e) => e?.toIso8601String())?.toList(),
      'ingredients': instance.ingredients,
      'nutriments': instance.nutriments,
      'dataComplete': instance.dataComplete
    };
