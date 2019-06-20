// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) {
  return Request(
      fridgeId: json['fridge_id'] as String,
      method: json['method'] as String,
      state: json['state'] as int,
      barcodes: (json['barcodes'] as List)?.map((e) => e as String)?.toList(),
      update: json['update'] as String);
}

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'fridge_id': instance.fridgeId,
      'method': instance.method,
      'state': instance.state,
      'barcodes': instance.barcodes,
      'update': instance.update
    };
