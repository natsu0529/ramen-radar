// Core domain models for Ramen Radar (framework-agnostic).

enum Genre {
  all,
  iekei,
  jiro,
}

/// Optional descriptive tags shown in the list.
enum RamenTag {
  iekei,
  jiro,
}

class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);
}

class Place {
  final String id; // e.g., Google Place ID
  final String name;
  final double? rating; // 0..5
  final LatLng location;
  final List<RamenTag> tags;
  final int? userRatingsTotal;
  final int? priceLevel;
  final String? vicinity;
  final String? photoReference;

  const Place({
    required this.id,
    required this.name,
    this.rating,
    required this.location,
    this.tags = const [],
    this.userRatingsTotal,
    this.priceLevel,
    this.vicinity,
    this.photoReference,
  });

  Place copyWith({
    String? id,
    String? name,
    double? rating,
    LatLng? location,
    List<RamenTag>? tags,
    int? userRatingsTotal,
    int? priceLevel,
    String? vicinity,
    String? photoReference,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      priceLevel: priceLevel ?? this.priceLevel,
      vicinity: vicinity ?? this.vicinity,
      photoReference: photoReference ?? this.photoReference,
    );
  }
}

/// A nearby candidate place with pre-computed distance from the user.
class Candidate {
  final Place place;
  final double distanceKm; // raw distance in kilometers

  const Candidate({required this.place, required this.distanceKm});
}

class RankingEntry {
  final Place place;
  final double score; // computed by scoring formula
  final double roundedDistanceKm; // distance shown to user

  const RankingEntry({
    required this.place,
    required this.score,
    required this.roundedDistanceKm,
  });
}
