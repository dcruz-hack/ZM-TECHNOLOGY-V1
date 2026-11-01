import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOnline;
  const OfflineBanner({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    if (isOnline) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: const Color(0xFFB42318),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: const Row(children: [
        Icon(Icons.wifi_off, color: Colors.white, size: 18),
        SizedBox(width: 8),
        Expanded(child: Text('Sin conexión · Mostrando contenido disponible localmente',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}
