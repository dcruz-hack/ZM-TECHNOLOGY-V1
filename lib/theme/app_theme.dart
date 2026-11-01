import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF101827);
  static const blue = Color(0xFF2563EB);
  static const cyan = Color(0xFF22D3EE);
  static const surface = Color(0xFFF3F6FB);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: blue, brightness: Brightness.light),
    scaffoldBackgroundColor: surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: navy, foregroundColor: Colors.white,
      centerTitle: false, elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white, elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}
