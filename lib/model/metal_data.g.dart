// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metal_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetalData _$MetalDataFromJson(Map<String, dynamic> json) {
  return MetalData(
    id: json['id'] as int,
    date: json['date'] as String,
    detail: json['detail'] as String,
    location: json['location'] as String,
    status: json['status'] as String,
    remark: json['remark'] as String,
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
