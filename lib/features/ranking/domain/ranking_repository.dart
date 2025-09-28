import 'package:ramen_radar/models.dart';

abstract class RankingRepository {
  Future<List<Candidate>> fetchCandidates({
    required Genre genre,
    required LatLng current,
  });
}
