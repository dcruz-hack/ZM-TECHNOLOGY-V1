import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zm_technology_pro/providers/app_provider.dart';
import 'package:zm_technology_pro/screens/home_screen.dart';

void main() {
  testWidgets('Muestra la identidad y el catálogo de ZM TECHNOLOGY PRO',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('ZM TECHNOLOGY'), findsOneWidget);
    expect(find.text('Catálogo destacado'), findsOneWidget);
    expect(find.text('PC Gamer Ryzen 5'), findsOneWidget);
    expect(find.text('Laptop Core i5'), findsOneWidget);
  });
}
