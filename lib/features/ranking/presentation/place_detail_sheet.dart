import 'package:flutter/material.dart';
import 'package:ramen_radar/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ramen_radar/models.dart';

class PlaceDetailSheet extends StatelessWidget {
  const PlaceDetailSheet({super.key, required this.entry});
  final RankingEntry entry;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(child: Text(entry.score.toStringAsFixed(1))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.place.name, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('${t.rating(entry.place.rating?.toStringAsFixed(1) ?? 'N/A')} ・ ${t.distanceKm(_fmtDistance(entry.roundedDistanceKm))} ・ ${t.score(entry.score.toStringAsFixed(2))}'),
                    ],
                  ),
                ),
              ],
              ),
            ),
            const SizedBox(height: 12),
            if (entry.place.tags.isNotEmpty) _TagsRow(tags: entry.place.tags),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _openInMaps(entry.place.location),
                  icon: const Icon(Icons.map_outlined),
                  label: Text(t.openInMaps),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(MaterialLocalizations.of(context).closeButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _fmtDistance(double km) => km.toStringAsFixed(1);

class _TagsRow extends StatelessWidget {
  const _TagsRow({required this.tags});
  final List<RamenTag> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: tags.map((t) => Chip(label: Text(_tagToText(t)))).toList(),
    );
  }

  String _tagToText(RamenTag t) {
    switch (t) {
      case RamenTag.iekei:
        return '家系';
      case RamenTag.jiro:
        return '二郎系';
    }
  }
}

void showPlaceDetailSheet(BuildContext context, RankingEntry e) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => PlaceDetailSheet(entry: e),
  );
}

Future<void> _openInMaps(LatLng loc) async {
  final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${loc.lat},${loc.lng}');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
