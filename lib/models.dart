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
  miso,
  tonkotsu,
}

class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);
}

class Place {
  final String id; // e.g., Google Place ID
  final String name;
  final double rating; // 0..5
  final LatLng location;
  final List<RamenTag> tags;

  const Place({
    required this.id,
    required this.name,
    required this.rating,
    required this.location,
    this.tags = const [],
  });
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
