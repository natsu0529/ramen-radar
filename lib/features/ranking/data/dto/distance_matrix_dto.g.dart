// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance_matrix_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DistanceMatrixResponseImpl _$$DistanceMatrixResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DistanceMatrixResponseImpl(
      rows: (json['rows'] as List<dynamic>?)
              ?.map((e) => DistanceRow.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DistanceRow>[],
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$DistanceMatrixResponseImplToJson(
        _$DistanceMatrixResponseImpl instance) =>
    <String, dynamic>{
      'rows': instance.rows,
      'status': instance.status,
    };

_$DistanceRowImpl _$$DistanceRowImplFromJson(Map<String, dynamic> json) =>
    _$DistanceRowImpl(
      elements: (json['elements'] as List<dynamic>?)
              ?.map((e) => DistanceElement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DistanceElement>[],
    );

Map<String, dynamic> _$$DistanceRowImplToJson(_$DistanceRowImpl instance) =>
    <String, dynamic>{
      'elements': instance.elements,
    };

_$DistanceElementImpl _$$DistanceElementImplFromJson(
        Map<String, dynamic> json) =>
    _$DistanceElementImpl(
      distance: json['distance'] == null
          ? null
          : ValueText.fromJson(json['distance'] as Map<String, dynamic>),
      duration: json['duration'] == null
          ? null
          : ValueText.fromJson(json['duration'] as Map<String, dynamic>),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$DistanceElementImplToJson(
        _$DistanceElementImpl instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'status': instance.status,
    };

_$ValueTextImpl _$$ValueTextImplFromJson(Map<String, dynamic> json) =>
    _$ValueTextImpl(
      value: (json['value'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$$ValueTextImplToJson(_$ValueTextImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
    };
