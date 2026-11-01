import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/camera_service.dart';
import '../services/connectivity_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final ConnectivityService connectivity = ConnectivityService();
  final CameraService camera = CameraService();
  final NotificationService notifications = NotificationService();
  final StorageService storage = StorageService();
  int cachedProductCount = 0;
  StreamSubscription<bool>? _networkSubscription;
  bool isOnline = true;
  File? selectedImage;
  String? lastError;

  Future<void> initialize() async {
    try {
      await notifications.initialize();
    } catch (error) {
      lastError = 'No se pudo inicializar notificaciones: $error';
    }
    // Guarda un snapshot local del catálogo para conservar datos básicos sin red.
    const catalogSnapshot = [
      {'id': 1, 'title': 'PC Gamer Ryzen 5', 'price': 650.0},
      {'id': 2, 'title': 'Laptop Core i5', 'price': 480.0},
      {'id': 3, 'title': 'Monitor Monster Gamer', 'price': 180.0},
    ];
    try {
      await storage.saveCatalog(catalogSnapshot);
      cachedProductCount = (await storage.readCatalog()).length;
    } catch (error) {
      lastError = 'No se pudo preparar la caché local: $error';
    }
    await connectivity.start();
    isOnline = connectivity.isOnline;
    _networkSubscription = connectivity.statusStream.listen((online) {
      isOnline = online;
      notifyListeners();
      if (!online) {
        notifications.showEvent(
          title: 'Modo sin conexión',
          body: 'El catálogo local sigue disponible en el dispositivo.',
        );
      }
    });
    notifyListeners();
  }

  Future<void> takePhoto() => _runImageAction(camera.capture);
  Future<void> choosePhoto() => _runImageAction(camera.selectFromGallery);

  Future<void> _runImageAction(Future<File?> Function() action) async {
    lastError = null;
    try {
      selectedImage = await action();
      if (selectedImage != null) {
        await notifications.showEvent(
          title: 'Imagen procesada',
          body: 'La imagen está lista para previsualización.',
        );
      }
    } catch (error) {
      lastError = error.toString();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    connectivity.dispose();
    super.dispose();
  }
}
