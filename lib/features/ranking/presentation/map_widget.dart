import 'package:flutter/material.dart';
import 'package:ramen_radar/l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

import 'package:ramen_radar/models.dart';

typedef MapWidgetBuilder = Widget Function({
  required LatLng current,
  required List<RankingEntry> entries,
  required void Function(RankingEntry entry) onSelect,
});

Widget defaultMapWidgetBuilder({
  required LatLng current,
  required List<RankingEntry> entries,
  required void Function(RankingEntry entry) onSelect,
}) {
  final markers = entries
      .map((e) => gmap.Marker(
            markerId: gmap.MarkerId(e.place.id),
            position: gmap.LatLng(e.place.location.lat, e.place.location.lng),
            infoWindow: gmap.InfoWindow(
              title: e.place.name,
              snippet: '★${e.place.rating.toStringAsFixed(1)} / ${e.roundedDistanceKm.toStringAsFixed(2)}km / ${e.score.toStringAsFixed(2)}',
              onTap: () => onSelect(e),
            ),
          ))
      .toSet();

  return Builder(builder: (context) {
    return Semantics(
      label: AppLocalizations.of(context).mapViewA11y(entries.length.toString()),
      child: gmap.GoogleMap(
        initialCameraPosition: gmap.CameraPosition(
          target: gmap.LatLng(current.lat, current.lng),
          zoom: 14,
        ),
        markers: markers,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        compassEnabled: true,
        mapToolbarEnabled: false,
      ),
    );
  });
}
