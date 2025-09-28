// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'places_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlacesNearbyResponse _$PlacesNearbyResponseFromJson(Map<String, dynamic> json) {
  return _PlacesNearbyResponse.fromJson(json);
}

/// @nodoc
mixin _$PlacesNearbyResponse {
  List<PlaceResult> get results => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this PlacesNearbyResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlacesNearbyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlacesNearbyResponseCopyWith<PlacesNearbyResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlacesNearbyResponseCopyWith<$Res> {
  factory $PlacesNearbyResponseCopyWith(PlacesNearbyResponse value,
          $Res Function(PlacesNearbyResponse) then) =
      _$PlacesNearbyResponseCopyWithImpl<$Res, PlacesNearbyResponse>;
  @useResult
  $Res call({List<PlaceResult> results, String? status});
}

/// @nodoc
class _$PlacesNearbyResponseCopyWithImpl<$Res,
        $Val extends PlacesNearbyResponse>
    implements $PlacesNearbyResponseCopyWith<$Res> {
  _$PlacesNearbyResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlacesNearbyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<PlaceResult>,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlacesNearbyResponseImplCopyWith<$Res>
    implements $PlacesNearbyResponseCopyWith<$Res> {
  factory _$$PlacesNearbyResponseImplCopyWith(_$PlacesNearbyResponseImpl value,
          $Res Function(_$PlacesNearbyResponseImpl) then) =
      __$$PlacesNearbyResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PlaceResult> results, String? status});
}

/// @nodoc
class __$$PlacesNearbyResponseImplCopyWithImpl<$Res>
    extends _$PlacesNearbyResponseCopyWithImpl<$Res, _$PlacesNearbyResponseImpl>
    implements _$$PlacesNearbyResponseImplCopyWith<$Res> {
  __$$PlacesNearbyResponseImplCopyWithImpl(_$PlacesNearbyResponseImpl _value,
      $Res Function(_$PlacesNearbyResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlacesNearbyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? status = freezed,
  }) {
    return _then(_$PlacesNearbyResponseImpl(
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<PlaceResult>,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlacesNearbyResponseImpl implements _PlacesNearbyResponse {
  const _$PlacesNearbyResponseImpl(
      {final List<PlaceResult> results = const <PlaceResult>[], this.status})
      : _results = results;

  factory _$PlacesNearbyResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlacesNearbyResponseImplFromJson(json);

  final List<PlaceResult> _results;
  @override
  @JsonKey()
  List<PlaceResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final String? status;

  @override
  String toString() {
    return 'PlacesNearbyResponse(results: $results, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlacesNearbyResponseImpl &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_results), status);

  /// Create a copy of PlacesNearbyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlacesNearbyResponseImplCopyWith<_$PlacesNearbyResponseImpl>
      get copyWith =>
          __$$PlacesNearbyResponseImplCopyWithImpl<_$PlacesNearbyResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlacesNearbyResponseImplToJson(
      this,
    );
  }
}

abstract class _PlacesNearbyResponse implements PlacesNearbyResponse {
  const factory _PlacesNearbyResponse(
      {final List<PlaceResult> results,
      final String? status}) = _$PlacesNearbyResponseImpl;

  factory _PlacesNearbyResponse.fromJson(Map<String, dynamic> json) =
      _$PlacesNearbyResponseImpl.fromJson;

  @override
  List<PlaceResult> get results;
  @override
  String? get status;

  /// Create a copy of PlacesNearbyResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlacesNearbyResponseImplCopyWith<_$PlacesNearbyResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PlaceResult _$PlaceResultFromJson(Map<String, dynamic> json) {
  return _PlaceResult.fromJson(json);
}

/// @nodoc
mixin _$PlaceResult {
  @JsonKey(name: 'place_id')
  String get placeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  Geometry get geometry => throw _privateConstructorUsedError;

  /// Serializes this PlaceResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceResultCopyWith<PlaceResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceResultCopyWith<$Res> {
  factory $PlaceResultCopyWith(
          PlaceResult value, $Res Function(PlaceResult) then) =
      _$PlaceResultCopyWithImpl<$Res, PlaceResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'place_id') String placeId,
      String name,
      double? rating,
      Geometry geometry});

  $GeometryCopyWith<$Res> get geometry;
}

/// @nodoc
class _$PlaceResultCopyWithImpl<$Res, $Val extends PlaceResult>
    implements $PlaceResultCopyWith<$Res> {
  _$PlaceResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? name = null,
    Object? rating = freezed,
    Object? geometry = null,
  }) {
    return _then(_value.copyWith(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as Geometry,
    ) as $Val);
  }

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeometryCopyWith<$Res> get geometry {
    return $GeometryCopyWith<$Res>(_value.geometry, (value) {
      return _then(_value.copyWith(geometry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaceResultImplCopyWith<$Res>
    implements $PlaceResultCopyWith<$Res> {
  factory _$$PlaceResultImplCopyWith(
          _$PlaceResultImpl value, $Res Function(_$PlaceResultImpl) then) =
      __$$PlaceResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'place_id') String placeId,
      String name,
      double? rating,
      Geometry geometry});

  @override
  $GeometryCopyWith<$Res> get geometry;
}

/// @nodoc
class __$$PlaceResultImplCopyWithImpl<$Res>
    extends _$PlaceResultCopyWithImpl<$Res, _$PlaceResultImpl>
    implements _$$PlaceResultImplCopyWith<$Res> {
  __$$PlaceResultImplCopyWithImpl(
      _$PlaceResultImpl _value, $Res Function(_$PlaceResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? name = null,
    Object? rating = freezed,
    Object? geometry = null,
  }) {
    return _then(_$PlaceResultImpl(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as Geometry,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceResultImpl implements _PlaceResult {
  const _$PlaceResultImpl(
      {@JsonKey(name: 'place_id') required this.placeId,
      required this.name,
      this.rating,
      required this.geometry});

  factory _$PlaceResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceResultImplFromJson(json);

  @override
  @JsonKey(name: 'place_id')
  final String placeId;
  @override
  final String name;
  @override
  final double? rating;
  @override
  final Geometry geometry;

  @override
  String toString() {
    return 'PlaceResult(placeId: $placeId, name: $name, rating: $rating, geometry: $geometry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceResultImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.geometry, geometry) ||
                other.geometry == geometry));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, placeId, name, rating, geometry);

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceResultImplCopyWith<_$PlaceResultImpl> get copyWith =>
      __$$PlaceResultImplCopyWithImpl<_$PlaceResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceResultImplToJson(
      this,
    );
  }
}

abstract class _PlaceResult implements PlaceResult {
  const factory _PlaceResult(
      {@JsonKey(name: 'place_id') required final String placeId,
      required final String name,
      final double? rating,
      required final Geometry geometry}) = _$PlaceResultImpl;

  factory _PlaceResult.fromJson(Map<String, dynamic> json) =
      _$PlaceResultImpl.fromJson;

  @override
  @JsonKey(name: 'place_id')
  String get placeId;
  @override
  String get name;
  @override
  double? get rating;
  @override
  Geometry get geometry;

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceResultImplCopyWith<_$PlaceResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Geometry _$GeometryFromJson(Map<String, dynamic> json) {
  return _Geometry.fromJson(json);
}

/// @nodoc
mixin _$Geometry {
  GeoLocation get location => throw _privateConstructorUsedError;

  /// Serializes this Geometry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Geometry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeometryCopyWith<Geometry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeometryCopyWith<$Res> {
  factory $GeometryCopyWith(Geometry value, $Res Function(Geometry) then) =
      _$GeometryCopyWithImpl<$Res, Geometry>;
  @useResult
  $Res call({GeoLocation location});

  $GeoLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$GeometryCopyWithImpl<$Res, $Val extends Geometry>
    implements $GeometryCopyWith<$Res> {
  _$GeometryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Geometry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoLocation,
    ) as $Val);
  }

  /// Create a copy of Geometry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoLocationCopyWith<$Res> get location {
    return $GeoLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GeometryImplCopyWith<$Res>
    implements $GeometryCopyWith<$Res> {
  factory _$$GeometryImplCopyWith(
          _$GeometryImpl value, $Res Function(_$GeometryImpl) then) =
      __$$GeometryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GeoLocation location});

  @override
  $GeoLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$GeometryImplCopyWithImpl<$Res>
    extends _$GeometryCopyWithImpl<$Res, _$GeometryImpl>
    implements _$$GeometryImplCopyWith<$Res> {
  __$$GeometryImplCopyWithImpl(
      _$GeometryImpl _value, $Res Function(_$GeometryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Geometry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_$GeometryImpl(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoLocation,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeometryImpl implements _Geometry {
  const _$GeometryImpl({required this.location});

  factory _$GeometryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeometryImplFromJson(json);

  @override
  final GeoLocation location;

  @override
  String toString() {
    return 'Geometry(location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeometryImpl &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, location);

  /// Create a copy of Geometry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeometryImplCopyWith<_$GeometryImpl> get copyWith =>
      __$$GeometryImplCopyWithImpl<_$GeometryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeometryImplToJson(
      this,
    );
  }
}

abstract class _Geometry implements Geometry {
  const factory _Geometry({required final GeoLocation location}) =
      _$GeometryImpl;

  factory _Geometry.fromJson(Map<String, dynamic> json) =
      _$GeometryImpl.fromJson;

  @override
  GeoLocation get location;

  /// Create a copy of Geometry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeometryImplCopyWith<_$GeometryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeoLocation _$GeoLocationFromJson(Map<String, dynamic> json) {
  return _GeoLocation.fromJson(json);
}

/// @nodoc
mixin _$GeoLocation {
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;

  /// Serializes this GeoLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeoLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeoLocationCopyWith<GeoLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoLocationCopyWith<$Res> {
  factory $GeoLocationCopyWith(
          GeoLocation value, $Res Function(GeoLocation) then) =
      _$GeoLocationCopyWithImpl<$Res, GeoLocation>;
  @useResult
  $Res call({double lat, double lng});
}

/// @nodoc
class _$GeoLocationCopyWithImpl<$Res, $Val extends GeoLocation>
    implements $GeoLocationCopyWith<$Res> {
  _$GeoLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeoLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_value.copyWith(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeoLocationImplCopyWith<$Res>
    implements $GeoLocationCopyWith<$Res> {
  factory _$$GeoLocationImplCopyWith(
          _$GeoLocationImpl value, $Res Function(_$GeoLocationImpl) then) =
      __$$GeoLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double lat, double lng});
}

/// @nodoc
class __$$GeoLocationImplCopyWithImpl<$Res>
    extends _$GeoLocationCopyWithImpl<$Res, _$GeoLocationImpl>
    implements _$$GeoLocationImplCopyWith<$Res> {
  __$$GeoLocationImplCopyWithImpl(
      _$GeoLocationImpl _value, $Res Function(_$GeoLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeoLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_$GeoLocationImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeoLocationImpl implements _GeoLocation {
  const _$GeoLocationImpl({required this.lat, required this.lng});

  factory _$GeoLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeoLocationImplFromJson(json);

  @override
  final double lat;
  @override
  final double lng;

  @override
  String toString() {
    return 'GeoLocation(lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeoLocationImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng);

  /// Create a copy of GeoLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeoLocationImplCopyWith<_$GeoLocationImpl> get copyWith =>
      __$$GeoLocationImplCopyWithImpl<_$GeoLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeoLocationImplToJson(
      this,
    );
  }
}

abstract class _GeoLocation implements GeoLocation {
  const factory _GeoLocation(
      {required final double lat,
      required final double lng}) = _$GeoLocationImpl;

  factory _GeoLocation.fromJson(Map<String, dynamic> json) =
      _$GeoLocationImpl.fromJson;

  @override
  double get lat;
  @override
  double get lng;

  /// Create a copy of GeoLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeoLocationImplCopyWith<_$GeoLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
