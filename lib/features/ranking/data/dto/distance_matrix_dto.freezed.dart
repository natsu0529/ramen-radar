// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'distance_matrix_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DistanceMatrixResponse _$DistanceMatrixResponseFromJson(
    Map<String, dynamic> json) {
  return _DistanceMatrixResponse.fromJson(json);
}

/// @nodoc
mixin _$DistanceMatrixResponse {
  List<DistanceRow> get rows => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this DistanceMatrixResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DistanceMatrixResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DistanceMatrixResponseCopyWith<DistanceMatrixResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DistanceMatrixResponseCopyWith<$Res> {
  factory $DistanceMatrixResponseCopyWith(DistanceMatrixResponse value,
          $Res Function(DistanceMatrixResponse) then) =
      _$DistanceMatrixResponseCopyWithImpl<$Res, DistanceMatrixResponse>;
  @useResult
  $Res call({List<DistanceRow> rows, String? status});
}

/// @nodoc
class _$DistanceMatrixResponseCopyWithImpl<$Res,
        $Val extends DistanceMatrixResponse>
    implements $DistanceMatrixResponseCopyWith<$Res> {
  _$DistanceMatrixResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DistanceMatrixResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rows = null,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<DistanceRow>,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DistanceMatrixResponseImplCopyWith<$Res>
    implements $DistanceMatrixResponseCopyWith<$Res> {
  factory _$$DistanceMatrixResponseImplCopyWith(
          _$DistanceMatrixResponseImpl value,
          $Res Function(_$DistanceMatrixResponseImpl) then) =
      __$$DistanceMatrixResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DistanceRow> rows, String? status});
}

/// @nodoc
class __$$DistanceMatrixResponseImplCopyWithImpl<$Res>
    extends _$DistanceMatrixResponseCopyWithImpl<$Res,
        _$DistanceMatrixResponseImpl>
    implements _$$DistanceMatrixResponseImplCopyWith<$Res> {
  __$$DistanceMatrixResponseImplCopyWithImpl(
      _$DistanceMatrixResponseImpl _value,
      $Res Function(_$DistanceMatrixResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DistanceMatrixResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rows = null,
    Object? status = freezed,
  }) {
    return _then(_$DistanceMatrixResponseImpl(
      rows: null == rows
          ? _value._rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<DistanceRow>,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DistanceMatrixResponseImpl implements _DistanceMatrixResponse {
  const _$DistanceMatrixResponseImpl(
      {final List<DistanceRow> rows = const <DistanceRow>[], this.status})
      : _rows = rows;

  factory _$DistanceMatrixResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DistanceMatrixResponseImplFromJson(json);

  final List<DistanceRow> _rows;
  @override
  @JsonKey()
  List<DistanceRow> get rows {
    if (_rows is EqualUnmodifiableListView) return _rows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rows);
  }

  @override
  final String? status;

  @override
  String toString() {
    return 'DistanceMatrixResponse(rows: $rows, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DistanceMatrixResponseImpl &&
            const DeepCollectionEquality().equals(other._rows, _rows) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_rows), status);

  /// Create a copy of DistanceMatrixResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DistanceMatrixResponseImplCopyWith<_$DistanceMatrixResponseImpl>
      get copyWith => __$$DistanceMatrixResponseImplCopyWithImpl<
          _$DistanceMatrixResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DistanceMatrixResponseImplToJson(
      this,
    );
  }
}

abstract class _DistanceMatrixResponse implements DistanceMatrixResponse {
  const factory _DistanceMatrixResponse(
      {final List<DistanceRow> rows,
      final String? status}) = _$DistanceMatrixResponseImpl;

  factory _DistanceMatrixResponse.fromJson(Map<String, dynamic> json) =
      _$DistanceMatrixResponseImpl.fromJson;

  @override
  List<DistanceRow> get rows;
  @override
  String? get status;

  /// Create a copy of DistanceMatrixResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DistanceMatrixResponseImplCopyWith<_$DistanceMatrixResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DistanceRow _$DistanceRowFromJson(Map<String, dynamic> json) {
  return _DistanceRow.fromJson(json);
}

/// @nodoc
mixin _$DistanceRow {
  List<DistanceElement> get elements => throw _privateConstructorUsedError;

  /// Serializes this DistanceRow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DistanceRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DistanceRowCopyWith<DistanceRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DistanceRowCopyWith<$Res> {
  factory $DistanceRowCopyWith(
          DistanceRow value, $Res Function(DistanceRow) then) =
      _$DistanceRowCopyWithImpl<$Res, DistanceRow>;
  @useResult
  $Res call({List<DistanceElement> elements});
}

/// @nodoc
class _$DistanceRowCopyWithImpl<$Res, $Val extends DistanceRow>
    implements $DistanceRowCopyWith<$Res> {
  _$DistanceRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DistanceRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elements = null,
  }) {
    return _then(_value.copyWith(
      elements: null == elements
          ? _value.elements
          : elements // ignore: cast_nullable_to_non_nullable
              as List<DistanceElement>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DistanceRowImplCopyWith<$Res>
    implements $DistanceRowCopyWith<$Res> {
  factory _$$DistanceRowImplCopyWith(
          _$DistanceRowImpl value, $Res Function(_$DistanceRowImpl) then) =
      __$$DistanceRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DistanceElement> elements});
}

/// @nodoc
class __$$DistanceRowImplCopyWithImpl<$Res>
    extends _$DistanceRowCopyWithImpl<$Res, _$DistanceRowImpl>
    implements _$$DistanceRowImplCopyWith<$Res> {
  __$$DistanceRowImplCopyWithImpl(
      _$DistanceRowImpl _value, $Res Function(_$DistanceRowImpl) _then)
      : super(_value, _then);

  /// Create a copy of DistanceRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elements = null,
  }) {
    return _then(_$DistanceRowImpl(
      elements: null == elements
          ? _value._elements
          : elements // ignore: cast_nullable_to_non_nullable
              as List<DistanceElement>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DistanceRowImpl implements _DistanceRow {
  const _$DistanceRowImpl(
      {final List<DistanceElement> elements = const <DistanceElement>[]})
      : _elements = elements;

  factory _$DistanceRowImpl.fromJson(Map<String, dynamic> json) =>
      _$$DistanceRowImplFromJson(json);

  final List<DistanceElement> _elements;
  @override
  @JsonKey()
  List<DistanceElement> get elements {
    if (_elements is EqualUnmodifiableListView) return _elements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_elements);
  }

  @override
  String toString() {
    return 'DistanceRow(elements: $elements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DistanceRowImpl &&
            const DeepCollectionEquality().equals(other._elements, _elements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_elements));

  /// Create a copy of DistanceRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DistanceRowImplCopyWith<_$DistanceRowImpl> get copyWith =>
      __$$DistanceRowImplCopyWithImpl<_$DistanceRowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DistanceRowImplToJson(
      this,
    );
  }
}

abstract class _DistanceRow implements DistanceRow {
  const factory _DistanceRow({final List<DistanceElement> elements}) =
      _$DistanceRowImpl;

  factory _DistanceRow.fromJson(Map<String, dynamic> json) =
      _$DistanceRowImpl.fromJson;

  @override
  List<DistanceElement> get elements;

  /// Create a copy of DistanceRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DistanceRowImplCopyWith<_$DistanceRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DistanceElement _$DistanceElementFromJson(Map<String, dynamic> json) {
  return _DistanceElement.fromJson(json);
}

/// @nodoc
mixin _$DistanceElement {
  ValueText? get distance => throw _privateConstructorUsedError;
  ValueText? get duration => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this DistanceElement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DistanceElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DistanceElementCopyWith<DistanceElement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DistanceElementCopyWith<$Res> {
  factory $DistanceElementCopyWith(
          DistanceElement value, $Res Function(DistanceElement) then) =
      _$DistanceElementCopyWithImpl<$Res, DistanceElement>;
  @useResult
  $Res call({ValueText? distance, ValueText? duration, String? status});

  $ValueTextCopyWith<$Res>? get distance;
  $ValueTextCopyWith<$Res>? get duration;
}

/// @nodoc
class _$DistanceElementCopyWithImpl<$Res, $Val extends DistanceElement>
    implements $DistanceElementCopyWith<$Res> {
  _$DistanceElementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DistanceElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distance = freezed,
    Object? duration = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as ValueText?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as ValueText?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of DistanceElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ValueTextCopyWith<$Res>? get distance {
    if (_value.distance == null) {
      return null;
    }

    return $ValueTextCopyWith<$Res>(_value.distance!, (value) {
      return _then(_value.copyWith(distance: value) as $Val);
    });
  }

  /// Create a copy of DistanceElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ValueTextCopyWith<$Res>? get duration {
    if (_value.duration == null) {
      return null;
    }

    return $ValueTextCopyWith<$Res>(_value.duration!, (value) {
      return _then(_value.copyWith(duration: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DistanceElementImplCopyWith<$Res>
    implements $DistanceElementCopyWith<$Res> {
  factory _$$DistanceElementImplCopyWith(_$DistanceElementImpl value,
          $Res Function(_$DistanceElementImpl) then) =
      __$$DistanceElementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ValueText? distance, ValueText? duration, String? status});

  @override
  $ValueTextCopyWith<$Res>? get distance;
  @override
  $ValueTextCopyWith<$Res>? get duration;
}

/// @nodoc
class __$$DistanceElementImplCopyWithImpl<$Res>
    extends _$DistanceElementCopyWithImpl<$Res, _$DistanceElementImpl>
    implements _$$DistanceElementImplCopyWith<$Res> {
  __$$DistanceElementImplCopyWithImpl(
      _$DistanceElementImpl _value, $Res Function(_$DistanceElementImpl) _then)
      : super(_value, _then);

  /// Create a copy of DistanceElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distance = freezed,
    Object? duration = freezed,
    Object? status = freezed,
  }) {
    return _then(_$DistanceElementImpl(
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as ValueText?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as ValueText?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DistanceElementImpl implements _DistanceElement {
  const _$DistanceElementImpl({this.distance, this.duration, this.status});

  factory _$DistanceElementImpl.fromJson(Map<String, dynamic> json) =>
      _$$DistanceElementImplFromJson(json);

  @override
  final ValueText? distance;
  @override
  final ValueText? duration;
  @override
  final String? status;

  @override
  String toString() {
    return 'DistanceElement(distance: $distance, duration: $duration, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DistanceElementImpl &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, distance, duration, status);

  /// Create a copy of DistanceElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DistanceElementImplCopyWith<_$DistanceElementImpl> get copyWith =>
      __$$DistanceElementImplCopyWithImpl<_$DistanceElementImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DistanceElementImplToJson(
      this,
    );
  }
}

abstract class _DistanceElement implements DistanceElement {
  const factory _DistanceElement(
      {final ValueText? distance,
      final ValueText? duration,
      final String? status}) = _$DistanceElementImpl;

  factory _DistanceElement.fromJson(Map<String, dynamic> json) =
      _$DistanceElementImpl.fromJson;

  @override
  ValueText? get distance;
  @override
  ValueText? get duration;
  @override
  String? get status;

  /// Create a copy of DistanceElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DistanceElementImplCopyWith<_$DistanceElementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ValueText _$ValueTextFromJson(Map<String, dynamic> json) {
  return _ValueText.fromJson(json);
}

/// @nodoc
mixin _$ValueText {
  int get value => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  /// Serializes this ValueText to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ValueText
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValueTextCopyWith<ValueText> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValueTextCopyWith<$Res> {
  factory $ValueTextCopyWith(ValueText value, $Res Function(ValueText) then) =
      _$ValueTextCopyWithImpl<$Res, ValueText>;
  @useResult
  $Res call({int value, String text});
}

/// @nodoc
class _$ValueTextCopyWithImpl<$Res, $Val extends ValueText>
    implements $ValueTextCopyWith<$Res> {
  _$ValueTextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValueText
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValueTextImplCopyWith<$Res>
    implements $ValueTextCopyWith<$Res> {
  factory _$$ValueTextImplCopyWith(
          _$ValueTextImpl value, $Res Function(_$ValueTextImpl) then) =
      __$$ValueTextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int value, String text});
}

/// @nodoc
class __$$ValueTextImplCopyWithImpl<$Res>
    extends _$ValueTextCopyWithImpl<$Res, _$ValueTextImpl>
    implements _$$ValueTextImplCopyWith<$Res> {
  __$$ValueTextImplCopyWithImpl(
      _$ValueTextImpl _value, $Res Function(_$ValueTextImpl) _then)
      : super(_value, _then);

  /// Create a copy of ValueText
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? text = null,
  }) {
    return _then(_$ValueTextImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValueTextImpl implements _ValueText {
  const _$ValueTextImpl({required this.value, required this.text});

  factory _$ValueTextImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValueTextImplFromJson(json);

  @override
  final int value;
  @override
  final String text;

  @override
  String toString() {
    return 'ValueText(value: $value, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValueTextImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value, text);

  /// Create a copy of ValueText
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValueTextImplCopyWith<_$ValueTextImpl> get copyWith =>
      __$$ValueTextImplCopyWithImpl<_$ValueTextImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ValueTextImplToJson(
      this,
    );
  }
}

abstract class _ValueText implements ValueText {
  const factory _ValueText(
      {required final int value, required final String text}) = _$ValueTextImpl;

  factory _ValueText.fromJson(Map<String, dynamic> json) =
      _$ValueTextImpl.fromJson;

  @override
  int get value;
  @override
  String get text;

  /// Create a copy of ValueText
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValueTextImplCopyWith<_$ValueTextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
