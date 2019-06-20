// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUpdate _$ItemUpdateFromJson(Map<String, dynamic> json) {
  return ItemUpdate(
      method: json['method'] as int,
      methodName: json['method_name'] as String,
      barcode: json['barcode'] as String,
      timestamp: json['timestamp'] as int,
      name: json['name'] as String);
}

Map<String, dynamic> _$ItemUpdateToJson(ItemUpdate instance) =>
    <String, dynamic>{
      'method': instance.method,
      'method_name': instance.methodName,
      'barcode': instance.barcode,
      'name': instance.name,
      'timestamp': instance.timestamp
    };
