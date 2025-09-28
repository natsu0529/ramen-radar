import 'package:flutter/material.dart';
import 'features/ranking/presentation/home_page.dart';

class RamenRadarApp extends StatelessWidget {
  const RamenRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramen Radar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
