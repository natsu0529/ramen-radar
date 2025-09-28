import 'package:flutter/material.dart';

Color scoreColor(ColorScheme scheme, double score) {
  // Map 0..10 to red -> orange -> green
  final clamped = score.clamp(0.0, 10.0);
  if (clamped >= 8.0) return Colors.green.shade600;
  if (clamped >= 6.5) return Colors.lightGreen.shade600;
  if (clamped >= 5.5) return Colors.amber.shade700;
  if (clamped >= 4.0) return Colors.deepOrange.shade600;
  return Colors.red.shade700;
}

