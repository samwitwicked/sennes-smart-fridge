// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return Response(
      error: json['error'] as int,
      errorMessage: json['error_msg'] as String,
      newState: json['new_state'] as int,
      updates: (json['updates'] as List)?.map((e) => e as String)?.toList(),
      barcodeInfo: (json['info'] as List)
          ?.map((e) => e as Map<String, dynamic>)
          ?.toList());
}

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'error': instance.error,
      'error_msg': instance.errorMessage,
      'new_state': instance.newState,
      'updates': instance.updates,
      'info': instance.barcodeInfo
    };
