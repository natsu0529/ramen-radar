import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import 'package:ramen_radar/models.dart';

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
    print('=== DEBUG: LocationService.getCurrentLatLng START ===');
    
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('DEBUG: Location service enabled: $serviceEnabled');
    if (!serviceEnabled) {
      print('DEBUG: Location service disabled, throwing exception');
      throw LocationException('service_disabled', '位置情報サービスが無効です');
    }

    var permission = await Geolocator.checkPermission();
    print('DEBUG: Initial permission status: $permission');
    if (permission == LocationPermission.denied) {
      print('DEBUG: Requesting location permission');
      permission = await Geolocator.requestPermission();
      print('DEBUG: Permission after request: $permission');
    }

    if (permission == LocationPermission.denied) {
      print('DEBUG: Permission denied, throwing exception');
      throw LocationException('permission_denied', '位置情報の権限が拒否されました');
    }
    if (permission == LocationPermission.deniedForever) {
      print('DEBUG: Permission denied forever, throwing exception');
      throw LocationException('permission_denied_forever', '位置情報の権限が恒久的に拒否されています');
    }

    print('DEBUG: Getting current position with accuracy: $accuracy, timeout: $timeout');
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: accuracy).timeout(timeout, onTimeout: () {
      print('DEBUG: Location timeout occurred');
      throw LocationException('timeout', '現在地の取得がタイムアウトしました');
    });
    final result = LatLng(pos.latitude, pos.longitude);
    print('DEBUG: Location obtained successfully: $result');
    return result;
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
