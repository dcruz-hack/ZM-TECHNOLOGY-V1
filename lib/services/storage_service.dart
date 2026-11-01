import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia local sencilla para conservar el catálogo serializado.
class StorageService {
  static const _catalogKey = 'zm_catalog_cache_v1';

  Future<void> saveCatalog(List<Map<String, dynamic>> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_catalogKey, jsonEncode(products));
  }

  Future<List<Map<String, dynamic>>> readCatalog() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_catalogKey);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } on FormatException {
      return [];
    } on TypeError {
      return [];
    }
  }
}
