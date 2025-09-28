import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// connectivity_plus v6 emits Stream<List<ConnectivityResult>>
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
});

bool isOffline(List<ConnectivityResult> r) {
  if (r.isEmpty) return true;
  return r.every((e) => e == ConnectivityResult.none);
}
