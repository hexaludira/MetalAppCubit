// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metal_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetalData _$MetalDataFromJson(Map<String, dynamic> json) {
  return MetalData(
    json['id'] as int,
    json['date'] as String,
    json['detail'] as String,
    json['location'] as String,
    json['status'] as String,
    json['remark'] as String,
  );
}

Map<String, dynamic> _$MetalDataToJson(MetalData instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'detail': instance.detail,
      'location': instance.location,
      'status': instance.status,
      'remark': instance.remark,
    };
