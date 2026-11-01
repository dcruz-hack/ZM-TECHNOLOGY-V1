import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Servicio desacoplado que publica cambios del tipo de conexión.
/// La conectividad del sistema no garantiza por sí sola acceso a Internet.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _controller = StreamController<bool>.broadcast();
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  Stream<bool> get statusStream => _controller.stream;

  Future<void> start() async {
    await _update(await _connectivity.checkConnectivity());
    _subscription ??= _connectivity.onConnectivityChanged.listen(_update);
  }

  Future<void> _update(List<ConnectivityResult> results) async {
    final hasNetwork = results.any((r) => r != ConnectivityResult.none);
    // Verifica acceso real a Internet, no solo que exista Wi-Fi/datos activos.
    final online = hasNetwork && await InternetConnection().hasInternetAccess;
    if (online != _isOnline) {
      _isOnline = online;
      _controller.add(online);
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}
