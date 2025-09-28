import 'package:dio/dio.dart';

import '../../../models.dart';

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
    final results = (data['results'] as List?) ?? [];
    return results.map((e) => _placeFromJson(e as Map<String, dynamic>)).where((p) => p != null).cast<Place>().toList();
  }

  Place? _placeFromJson(Map<String, dynamic> json) {
    final id = json['place_id'] as String?;
    final name = json['name'] as String?;
    final rating = (json['rating'] as num?)?.toDouble() ?? 0.0;
    final loc = ((json['geometry'] as Map?)?['location'] as Map?) ?? {};
    final lat = (loc['lat'] as num?)?.toDouble();
    final lng = (loc['lng'] as num?)?.toDouble();
    if (id == null || name == null || lat == null || lng == null) return null;

    final tags = <RamenTag>[];
    final nameLower = name.toLowerCase();
    if (nameLower.contains('家系')) tags.add(RamenTag.iekei);
    if (nameLower.contains('二郎')) tags.add(RamenTag.jiro);
    if (nameLower.contains('味噌')) tags.add(RamenTag.miso);
    if (nameLower.contains('豚骨') || nameLower.contains('とんこつ')) tags.add(RamenTag.tonkotsu);

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
    final rows = (data['rows'] as List?) ?? [];
    if (rows.isEmpty) return List.filled(destinations.length, double.nan);
    final elements = (rows.first as Map)['elements'] as List? ?? [];
    return elements.map((e) {
      final el = e as Map<String, dynamic>;
      if (el['status'] != 'OK') return double.nan;
      final meters = (el['distance'] as Map)['value'] as num;
      return meters.toDouble() / 1000.0;
    }).toList();
  }
}

