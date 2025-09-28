import 'package:flutter/material.dart';

ThemeData appTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
    useMaterial3: true,
    materialTapTargetSize: MaterialTapTargetSize.padded,
  );
  return base.copyWith(
    listTileTheme: const ListTileThemeData(
      dense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(minimumSize: const Size(48, 48), padding: const EdgeInsets.symmetric(horizontal: 16)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48), padding: const EdgeInsets.symmetric(horizontal: 16)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48), padding: const EdgeInsets.symmetric(horizontal: 16)),
    ),
    chipTheme: base.chipTheme.copyWith(
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
