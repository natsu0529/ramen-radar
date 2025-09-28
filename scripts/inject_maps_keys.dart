import 'dart:io';

// A helper script to inject Google Maps API keys into platform files
// after running `flutter create . --platforms=android,ios,web`.
//
// Usage:
//   dart run scripts/inject_maps_keys.dart
//
// Reads GOOGLE_MAPS_API_KEY from environment variables or .env (if present),
// and updates:
//   - android/app/src/main/AndroidManifest.xml: <meta-data ... API KEY>
//   - android/app/build.gradle (Groovy only): manifestPlaceholders (MAPS_API_KEY)
//   - ios/Runner/Info.plist: GMSApiKey and location usage description
//   - web/index.html: <script src="https://maps.googleapis.com/maps/api/js?key=...">

Future<void> main() async {
  final key = await _loadApiKey();
  if (key == null || key.isEmpty) {
    stderr.writeln('[inject_maps_keys] GOOGLE_MAPS_API_KEY が見つかりません (.env もしくは環境変数)');
    exit(1);
  }

  await _patchAndroid(key);
  await _patchIOS(key);
  await _patchWeb(key);

  stdout.writeln('[inject_maps_keys] 完了しました');
}

Future<String?> _loadApiKey() async {
  // Prefer env var
  final envVal = Platform.environment['GOOGLE_MAPS_API_KEY'];
  if (envVal != null && envVal.isNotEmpty) return envVal;

  // Fallback: parse .env (very simple parser)
  final envFile = File('.env');
  if (await envFile.exists()) {
    final lines = await envFile.readAsLines();
    for (final l in lines) {
      final line = l.trim();
      if (line.startsWith('#') || line.isEmpty) continue;
      final idx = line.indexOf('=');
      if (idx <= 0) continue;
      final k = line.substring(0, idx).trim();
      var v = line.substring(idx + 1).trim();
      if (v.startsWith('"') && v.endsWith('"') && v.length >= 2) {
        v = v.substring(1, v.length - 1);
      }
      if (k == 'GOOGLE_MAPS_API_KEY') return v;
    }
  }
  return null;
}

Future<void> _patchAndroid(String key) async {
  final manifest = File('android/app/src/main/AndroidManifest.xml');
  final gradleGroovy = File('android/app/build.gradle');
  final gradleKts = File('android/app/build.gradle.kts');
  if (!await manifest.exists()) {
    stdout.writeln('[inject_maps_keys][android] スキップ（AndroidManifest.xml が見つかりません）');
    return;
  }

  // Patch AndroidManifest.xml: add meta-data if missing
  var manifestText = await manifest.readAsString();
  const placeholder = '__MAPS_API_KEY__';
  if (!manifestText.contains('com.google.android.geo.API_KEY')) {
    manifestText = manifestText.replaceFirst(
      '</application>',
      '    <meta-data android:name="com.google.android.geo.API_KEY" android:value="' + placeholder + '" />\n  </application>',
    );
  }
  manifestText = manifestText.replaceAll(placeholder, key);
  await manifest.writeAsString(manifestText);

  // Patch build.gradle (Groovy) when present. KTS は通知のみ。
  if (await gradleGroovy.exists()) {
    var gradleText = await gradleGroovy.readAsString();
    if (!gradleText.contains('manifestPlaceholders')) {
      gradleText = gradleText.replaceFirst(
        RegExp(r'defaultConfig\s*\{'),
        'defaultConfig {\n        manifestPlaceholders = [ MAPS_API_KEY: System.getenv("GOOGLE_MAPS_API_KEY") ?: project.findProperty("MAPS_API_KEY") ?: "${_escapeGradle(key)}" ]',
      );
      await gradleGroovy.writeAsString(gradleText);
    }
  } else if (await gradleKts.exists()) {
    stdout.writeln('[inject_maps_keys][android] build.gradle.kts を検出。manifestPlaceholders は手動で設定してください。');
  }

  stdout.writeln('[inject_maps_keys][android] 更新しました');
}

String _escapeGradle(String v) => v.replaceAll('"', '\\"');

Future<void> _patchIOS(String key) async {
  final plist = File('ios/Runner/Info.plist');
  if (!await plist.exists()) {
    stdout.writeln('[inject_maps_keys][ios] スキップ（iOS プロジェクトが見つかりません）');
    return;
  }
  var text = await plist.readAsString();
  if (!text.contains('<key>GMSApiKey</key>')) {
    text = text.replaceFirst(
      '</dict>\n</plist>',
      '  <key>GMSApiKey</key>\n  <string>${_xmlEscape(key)}</string>\n  <key>NSLocationWhenInUseUsageDescription</key>\n  <string>現在地を使用して近くのラーメン店を表示します</string>\n</dict>\n</plist>',
    );
  }
  await plist.writeAsString(text);
  stdout.writeln('[inject_maps_keys][ios] 更新しました');
}

String _xmlEscape(String v) => v
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

Future<void> _patchWeb(String key) async {
  final index = File('web/index.html');
  if (!await index.exists()) {
    stdout.writeln('[inject_maps_keys][web] スキップ（web プロジェクトが見つかりません）');
    return;
  }
  var html = await index.readAsString();
  if (!html.contains('maps.googleapis.com/maps/api/js')) {
    html = html.replaceFirst(
      '</head>',
      '  <script src="https://maps.googleapis.com/maps/api/js?key=${_htmlEscape(key)}"></script>\n</head>',
    );
  }
  await index.writeAsString(html);
  stdout.writeln('[inject_maps_keys][web] 更新しました');
}

String _htmlEscape(String v) => v
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

