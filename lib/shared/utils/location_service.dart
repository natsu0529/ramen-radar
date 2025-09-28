import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../models.dart';

class LocationException implements Exception {
  final String code;
  final String message;
  LocationException(this.code, this.message);

  @override
  String toString() => 'LocationException($code): $message';
}

class LocationService {
  /// Ensure services and permissions, then fetch current position.
  /// Throws [LocationException] when unavailable.
  Future<LatLng> getCurrentLatLng({LocationAccuracy accuracy = LocationAccuracy.high, Duration timeout = const Duration(seconds: 8)}) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('service_disabled', '位置情報サービスが無効です');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw LocationException('permission_denied', '位置情報の権限が拒否されました');
    }
    if (permission == LocationPermission.deniedForever) {
      throw LocationException('permission_denied_forever', '位置情報の権限が恒久的に拒否されています');
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: accuracy).timeout(timeout, onTimeout: () {
      throw LocationException('timeout', '現在地の取得がタイムアウトしました');
    });
    return LatLng(pos.latitude, pos.longitude);
  }

  /// Open system settings for the app.
  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }

  /// Open device location settings (to enable GPS/services).
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
