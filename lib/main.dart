import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = AppProvider();
  try {
    await provider.initialize();
  } catch (_) {
    // La interfaz debe abrir aunque un servicio nativo falle al inicializarse.
  }
  runApp(ChangeNotifierProvider.value(value: provider, child: const ZmTechnologyApp()));
}

class ZmTechnologyApp extends StatelessWidget {
  const ZmTechnologyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'ZM TECHNOLOGY V1',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const HomeScreen(),
  );
}
