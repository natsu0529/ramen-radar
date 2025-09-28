import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models.dart';

class PlaceDetailSheet extends StatelessWidget {
  const PlaceDetailSheet({super.key, required this.entry});
  final RankingEntry entry;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                      Text('${t.rating(entry.place.rating.toStringAsFixed(1))} ・ ${t.distanceKm(_fmtDistance(entry.roundedDistanceKm))} ・ ${t.score(entry.score.toStringAsFixed(2))}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (entry.place.tags.isNotEmpty) _TagsRow(tags: entry.place.tags),
          ],
        ),
      ),
    );
  }
}

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
      case RamenTag.miso:
        return '味噌';
      case RamenTag.tonkotsu:
        return '豚骨';
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
