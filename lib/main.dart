import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramen_radar/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Try to load .env but don't crash if missing in dev
  await dotenv.load(fileName: '.env').catchError((_) {});
  runApp(const ProviderScope(child: RamenRadarApp()));
}
