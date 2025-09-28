import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import 'package:ramen_radar/models.dart';
import 'package:ramen_radar/features/ranking/data/dto/places_dto.dart';
import 'package:ramen_radar/features/ranking/data/dto/distance_matrix_dto.dart';

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
    developer.log('GooglePlacesApi: searchNearbyRamen called with current=$current, genre=${genre.name}, radius=$radiusMeters');
    final keyword = switch (genre) {
      Genre.all => 'ramen',
      Genre.iekei => '家系 ラーメン',
      Genre.jiro => '二郎 ラーメン',
    };

    developer.log('GooglePlacesApi: Making API request with keyword="$keyword"');
    
    try {
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
      
      developer.log('GooglePlacesApi: API response status=${resp.statusCode}');
      developer.log('GooglePlacesApi: API response data keys=${(resp.data as Map<String, dynamic>).keys.toList()}');
      final data = resp.data as Map<String, dynamic>;
      final dto = PlacesNearbyResponse.fromJson(data);
      final places = dto.results.map(_placeFromDto).whereType<Place>().toList();
      
      developer.log('GooglePlacesApi: Found ${places.length} places');
      return places;
    } catch (e, stackTrace) {
      developer.log('GooglePlacesApi: Error during API call', error: e, stackTrace: stackTrace);
      rethrow;
    }
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
    developer.log('GoogleDistanceMatrixApi: distancesKm called with origin=$origin, destinations.length=${destinations.length}, mode=$mode');
    if (destinations.isEmpty) return const [];
    final destParam = destinations.map((d) => '${d.lat},${d.lng}').join('|');
    try {
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
      
      developer.log('GoogleDistanceMatrixApi: API response status=${resp.statusCode}');
      developer.log('GoogleDistanceMatrixApi: API response data keys=${(resp.data as Map<String, dynamic>).keys.toList()}');
      final data = resp.data as Map<String, dynamic>;
      final dto = DistanceMatrixResponse.fromJson(data);
      
      developer.log('GoogleDistanceMatrixApi: Response status=${dto.status}, rows.length=${dto.rows.length}');
      
      if (dto.rows.isEmpty) return List.filled(destinations.length, double.nan);
      final elements = dto.rows.first.elements;
      
      developer.log('GoogleDistanceMatrixApi: Elements.length=${elements.length}');
      
      final distances = elements.map((el) {
        developer.log('GoogleDistanceMatrixApi: Element status=${el.status}, distance=${el.distance?.value}');
        if (el.status != 'OK' || el.distance == null) return double.nan;
        final meters = el.distance!.value;
        return meters.toDouble() / 1000.0;
      }).toList();
      
      developer.log('GoogleDistanceMatrixApi: Returning ${distances.length} distances');
      return distances;
    } catch (e, stackTrace) {
      developer.log('GoogleDistanceMatrixApi: Error during API call', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
