import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/offline_banner.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Product> products = [
    Product(id: 1, title: 'PC Gamer Ryzen 5',
      description: 'Equipo gamer con 16 GB de RAM y SSD de 500 GB.',
      price: 650, image: '', icon: Icons.computer),
    Product(id: 2, title: 'Laptop Core i5',
      description: 'Laptop ideal para estudios y trabajo.',
      price: 480, image: '', icon: Icons.laptop),
    Product(id: 3, title: 'Monitor Monster Gamer',
      description: 'Monitor de 24 pulgadas con frecuencia de 144 Hz.',
      price: 180, image: '', icon: Icons.desktop_windows),
  ];

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet<void>(context: context, builder: (sheetContext) => SafeArea(
      child: Wrap(children: [
        ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Tomar fotografía'),
          onTap: () { Navigator.pop(sheetContext); context.read<AppProvider>().takePhoto(); }),
        ListTile(leading: const Icon(Icons.photo_library), title: const Text('Elegir de galería'),
          onTap: () { Navigator.pop(sheetContext); context.read<AppProvider>().choosePhoto(); }),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, app, _) => Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Icon(Icons.memory, color: AppTheme.cyan, size: 27),
          SizedBox(width: 9),
          Text('ZM TECHNOLOGY', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: .5)),
        ]),
        actions: [
          IconButton(tooltip: 'Probar notificación', icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () => app.notifications.showEvent(
              title: 'ZM TECHNOLOGY PRO', body: 'Las notificaciones locales están funcionando.')),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(children: [
        OfflineBanner(isOnline: app.isOnline),
        Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.navy, Color(0xFF1D4ED8)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('TECNOLOGÍA PARA\nLLEGAR MÁS LEJOS',
                style: TextStyle(color: Colors.white, fontSize: 23, height: 1.2, fontWeight: FontWeight.w900)),
              SizedBox(height: 10),
              Text('Explora equipos, accesorios y soluciones gamer.',
                style: TextStyle(color: Colors.white70, fontSize: 14)),
              SizedBox(height: 14),
              Row(children: [Icon(Icons.bolt, color: AppTheme.cyan), SizedBox(width: 6),
                Text('POTENCIA · CALIDAD · CONFIANZA',
                  style: TextStyle(color: AppTheme.cyan, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: .7))]),
            ]),
          ),
          const SizedBox(height: 22),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Catálogo destacado', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text('${products.length} productos', style: TextStyle(color: Colors.grey.shade600)),
          ]),
          const SizedBox(height: 10),
          ...products.map((product) => ProductCard(product: product, onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => DetailScreen(product: product))))),
          const SizedBox(height: 12),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Servicios del dispositivo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              const SizedBox(height: 8),
              const Text('Captura o selecciona una imagen. Se solicitarán los permisos necesarios.'),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: () => _showImageOptions(context),
                icon: const Icon(Icons.add_a_photo_outlined), label: const Text('Abrir cámara / galería')),
              if (app.selectedImage != null) ...[
                const SizedBox(height: 12),
                ClipRRect(borderRadius: BorderRadius.circular(12),
                  child: Image.file(app.selectedImage!, height: 180, width: double.infinity, fit: BoxFit.cover)),
              ],
              if (app.lastError != null) ...[
                const SizedBox(height: 8),
                Text(app.lastError!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ))),
          const SizedBox(height: 20),
          const Center(child: Text('ZM TECHNOLOGY PRO · Quito, Ecuador',
            style: TextStyle(color: Colors.black45, fontSize: 12))),
        ])),
      ]),
    ));
  }
}
