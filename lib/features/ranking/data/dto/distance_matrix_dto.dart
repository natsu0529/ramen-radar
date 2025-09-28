import 'package:freezed_annotation/freezed_annotation.dart';

part 'distance_matrix_dto.freezed.dart';
part 'distance_matrix_dto.g.dart';

@freezed
class DistanceMatrixResponse with _$DistanceMatrixResponse {
  const factory DistanceMatrixResponse({
    @Default(<DistanceRow>[]) List<DistanceRow> rows,
    String? status,
  }) = _DistanceMatrixResponse;

  factory DistanceMatrixResponse.fromJson(Map<String, dynamic> json) => _$DistanceMatrixResponseFromJson(json);
}

@freezed
class DistanceRow with _$DistanceRow {
  const factory DistanceRow({
    @Default(<DistanceElement>[]) List<DistanceElement> elements,
  }) = _DistanceRow;

  factory DistanceRow.fromJson(Map<String, dynamic> json) => _$DistanceRowFromJson(json);
}

@freezed
class DistanceElement with _$DistanceElement {
  const factory DistanceElement({
    ValueText? distance,
    ValueText? duration,
    String? status,
  }) = _DistanceElement;

  factory DistanceElement.fromJson(Map<String, dynamic> json) => _$DistanceElementFromJson(json);
}

@freezed
class ValueText with _$ValueText {
  const factory ValueText({
    required int value,
    required String text,
  }) = _ValueText;

  factory ValueText.fromJson(Map<String, dynamic> json) => _$ValueTextFromJson(json);
}

