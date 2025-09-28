// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlacesNearbyResponseImpl _$$PlacesNearbyResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PlacesNearbyResponseImpl(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => PlaceResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PlaceResult>[],
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$PlacesNearbyResponseImplToJson(
        _$PlacesNearbyResponseImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'status': instance.status,
    };

_$PlaceResultImpl _$$PlaceResultImplFromJson(Map<String, dynamic> json) =>
    _$PlaceResultImpl(
      placeId: json['place_id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PlaceResultImplToJson(_$PlaceResultImpl instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'name': instance.name,
      'rating': instance.rating,
      'geometry': instance.geometry,
    };

_$GeometryImpl _$$GeometryImplFromJson(Map<String, dynamic> json) =>
    _$GeometryImpl(
      location: GeoLocation.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GeometryImplToJson(_$GeometryImpl instance) =>
    <String, dynamic>{
      'location': instance.location,
    };

_$GeoLocationImpl _$$GeoLocationImplFromJson(Map<String, dynamic> json) =>
    _$GeoLocationImpl(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$$GeoLocationImplToJson(_$GeoLocationImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
