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
    
    // 全検索結果を取得
    final allPlaces = await searchAllRamenWithTags(
      current: current,
      radiusMeters: radiusMeters,
    );
    
    // ジャンルに応じてフィルタリング
    return allPlaces.where((place) {
      switch (genre) {
        case Genre.all:
          return true; // 全ての店舗を返す
        case Genre.iekei:
          return place.tags.contains(RamenTag.iekei);
        case Genre.jiro:
          return place.tags.contains(RamenTag.jiro);
      }
    }).toList();
  }

  /// 3つの検索を並行実行してタグ付きの全店舗を取得
  Future<List<Place>> searchAllRamenWithTags({
    required LatLng current,
    int radiusMeters = 2000,
  }) async {
    developer.log('GooglePlacesApi: searchAllRamenWithTags called with current=$current, radius=$radiusMeters');
    
    try {
      // 3つの検索を並行実行
      final futures = [
        _searchByKeyword(current, 'ラーメン', radiusMeters),
        _searchByKeyword(current, '家系ラーメン', radiusMeters),
        _searchByKeyword(current, '二郎系ラーメン', radiusMeters),
      ];
      
      final results = await Future.wait(futures);
      final allResults = results[0];
      final iekeiResults = results[1];
      final jiroResults = results[2];
      
      developer.log('GooglePlacesApi: Search results - all: ${allResults.length}, iekei: ${iekeiResults.length}, jiro: ${jiroResults.length}');
      
      // place_idをキーとしたマップを作成
      final placeMap = <String, Place>{};
      
      // 全ラーメン検索結果を基本として追加
      for (final result in allResults) {
        final place = _placeFromDto(result, null);
        if (place != null) {
          placeMap[place.id] = place;
          developer.log('GooglePlacesApi: Added base place: ${place.name} (id: ${place.id}, tags: ${place.tags})');
        }
      }
      developer.log('GooglePlacesApi: Base places added: ${placeMap.length}');
      
      // 家系ラーメン検索結果にタグを付与
      for (final result in iekeiResults) {
        final placeId = result.placeId;
        if (placeMap.containsKey(placeId)) {
          final existingPlace = placeMap[placeId]!;
          final updatedTags = [...existingPlace.tags, RamenTag.iekei];
          placeMap[placeId] = existingPlace.copyWith(tags: updatedTags);
          developer.log('GooglePlacesApi: Updated existing place with iekei tag: ${existingPlace.name} (tags: ${updatedTags})');
        } else {
          final place = _placeFromDto(result, null);
          if (place != null) {
            placeMap[placeId] = place.copyWith(tags: [RamenTag.iekei]);
            developer.log('GooglePlacesApi: Added new iekei place: ${place.name} (tags: [RamenTag.iekei])');
          }
        }
      }
      developer.log('GooglePlacesApi: After iekei processing: ${placeMap.length} places');
      
      // 二郎系ラーメン検索結果にタグを付与
      for (final result in jiroResults) {
        final placeId = result.placeId;
        if (placeMap.containsKey(placeId)) {
          final existingPlace = placeMap[placeId]!;
          final updatedTags = [...existingPlace.tags];
          if (!updatedTags.contains(RamenTag.jiro)) {
            updatedTags.add(RamenTag.jiro);
          }
          placeMap[placeId] = existingPlace.copyWith(tags: updatedTags);
          developer.log('GooglePlacesApi: Updated existing place with jiro tag: ${existingPlace.name} (tags: ${updatedTags})');
        } else {
          final place = _placeFromDto(result, null);
          if (place != null) {
            placeMap[placeId] = place.copyWith(tags: [RamenTag.jiro]);
            developer.log('GooglePlacesApi: Added new jiro place: ${place.name} (tags: [RamenTag.jiro])');
          }
        }
      }
      developer.log('GooglePlacesApi: After jiro processing: ${placeMap.length} places');
      
      final places = placeMap.values.toList();
      developer.log('GooglePlacesApi: Final result summary:');
      for (final place in places) {
        developer.log('  - ${place.name}: tags=${place.tags}');
      }
      developer.log('GooglePlacesApi: Found ${places.length} unique places with tags');
      return places;
    } catch (e, stackTrace) {
      developer.log('GooglePlacesApi: Error during searchAllRamenWithTags', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// キーワードで検索を実行
  Future<List<PlaceResult>> _searchByKeyword(
    LatLng current,
    String keyword,
    int radiusMeters,
  ) async {
    developer.log('GooglePlacesApi: Making API request with keyword="$keyword"');
    
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
    
    developer.log('GooglePlacesApi: API response status=${resp.statusCode} for keyword="$keyword"');
    final data = resp.data as Map<String, dynamic>;
    final dto = PlacesNearbyResponse.fromJson(data);
    
    return dto.results;
  }



  Place? _placeFromDto(PlaceResult dto, Genre? genre) {
    try {
      final location = dto.geometry.location;

      final place = Place(
        id: dto.placeId,
        name: dto.name,
        location: LatLng(location.lat, location.lng),
        rating: dto.rating,
        tags: [], // タグは新しいロジックで付与
      );
      
      developer.log('GooglePlacesApi: Created place: ${place.name}');
      return place;
    } catch (e, stackTrace) {
      developer.log('GooglePlacesApi: Error creating place from DTO', error: e, stackTrace: stackTrace);
      return null;
    }
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
