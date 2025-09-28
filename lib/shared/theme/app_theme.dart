import 'package:flutter/material.dart';

ThemeData appTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
    useMaterial3: true,
  );
  return base.copyWith(
    listTileTheme: const ListTileThemeData(dense: false),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

