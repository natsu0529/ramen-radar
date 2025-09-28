import 'package:freezed_annotation/freezed_annotation.dart';

part 'places_dto.freezed.dart';
part 'places_dto.g.dart';

@freezed
class PlacesNearbyResponse with _$PlacesNearbyResponse {
  const factory PlacesNearbyResponse({
    @Default(<PlaceResult>[]) List<PlaceResult> results,
    String? status,
  }) = _PlacesNearbyResponse;

  factory PlacesNearbyResponse.fromJson(Map<String, dynamic> json) => _$PlacesNearbyResponseFromJson(json);
}

@freezed
class PlaceResult with _$PlaceResult {
  const factory PlaceResult({
    @JsonKey(name: 'place_id') required String placeId,
    required String name,
    double? rating,
    required Geometry geometry,
  }) = _PlaceResult;

  factory PlaceResult.fromJson(Map<String, dynamic> json) => _$PlaceResultFromJson(json);
}

@freezed
class Geometry with _$Geometry {
  const factory Geometry({
    required GeoLocation location,
  }) = _Geometry;

  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);
}

@freezed
class GeoLocation with _$GeoLocation {
  const factory GeoLocation({
    required double lat,
    required double lng,
  }) = _GeoLocation;

  factory GeoLocation.fromJson(Map<String, dynamic> json) => _$GeoLocationFromJson(json);
}

