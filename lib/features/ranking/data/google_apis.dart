import 'package:dio/dio.dart';

import '../../../models.dart';
import 'dto/places_dto.dart';
import 'dto/distance_matrix_dto.dart';

class GooglePlacesApi {
  GooglePlacesApi(this._dio, {required this.apiKey});
  final Dio _dio;
  final String apiKey;

  /// Nearby search for ramen places around [current].
  /// Genre filter is approximated via keyword.
  Future<List<Place>> searchNearbyRamen({
    required LatLng current,
    required Genre genre,
    int radiusMeters = 2000,
  }) async {
    final keyword = switch (genre) {
      Genre.all => 'ramen',
      Genre.iekei => '家系 ラーメン',
      Genre.jiro => '二郎 ラーメン',
    };

    final resp = await _dio.get(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
      queryParameters: {
        'location': '${current.lat},${current.lng}',
        'radius': radiusMeters,
        'type': 'restaurant',
        'keyword': keyword,
        'key': apiKey,
        'language': 'ja',
      },
    );
    final data = resp.data as Map<String, dynamic>;
    final dto = PlacesNearbyResponse.fromJson(data);
    return dto.results.map(_placeFromDto).whereType<Place>().toList();
  }

  Place? _placeFromDto(PlaceResult r) {
    final id = r.placeId;
    final name = r.name;
    final rating = r.rating ?? 0.0;
    final lat = r.geometry.location.lat;
    final lng = r.geometry.location.lng;

    final tags = <RamenTag>[];
    final nameForMatch = name; // Japanese: case-insensitive not meaningful; keep raw
    if (nameForMatch.contains('家系')) tags.add(RamenTag.iekei);
    if (nameForMatch.contains('二郎')) tags.add(RamenTag.jiro);
    if (nameForMatch.contains('味噌')) tags.add(RamenTag.miso);
    if (nameForMatch.contains('豚骨') || nameForMatch.contains('とんこつ')) tags.add(RamenTag.tonkotsu);

    return Place(
      id: id,
      name: name,
      rating: rating,
      location: LatLng(lat, lng),
      tags: tags,
    );
  }
}

class GoogleDistanceMatrixApi {
  GoogleDistanceMatrixApi(this._dio, {required this.apiKey});
  final Dio _dio;
  final String apiKey;

  /// Returns distances in kilometers for each destination from origin.
  Future<List<double>> distancesKm({
    required LatLng origin,
    required List<LatLng> destinations,
    String mode = 'walking',
  }) async {
    if (destinations.isEmpty) return const [];
    final destParam = destinations.map((d) => '${d.lat},${d.lng}').join('|');
    final resp = await _dio.get(
      'https://maps.googleapis.com/maps/api/distancematrix/json',
      queryParameters: {
        'origins': '${origin.lat},${origin.lng}',
        'destinations': destParam,
        'mode': mode,
        'key': apiKey,
        'language': 'ja',
      },
    );
    final data = resp.data as Map<String, dynamic>;
    final dto = DistanceMatrixResponse.fromJson(data);
    if (dto.rows.isEmpty) return List.filled(destinations.length, double.nan);
    final elements = dto.rows.first.elements;
    return elements.map((el) {
      if (el.status != 'OK' || el.distance == null) return double.nan;
      final meters = el.distance!.value;
      return meters.toDouble() / 1000.0;
    }).toList();
  }
}
