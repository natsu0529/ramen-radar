import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramen_radar/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Try to load .env but don't crash if missing in dev
  await dotenv.load(fileName: '.env').catchError((_) {});
  print('DEBUG: .env loaded, USE_GOOGLE_API = ${dotenv.env['USE_GOOGLE_API']}');
  print('DEBUG: All env vars: ${dotenv.env}');
  runApp(const ProviderScope(child: RamenRadarApp()));
}
