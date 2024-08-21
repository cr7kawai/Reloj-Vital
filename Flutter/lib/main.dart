import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importa para inicializar la localización
import 'package:instrumento/config/theme/app_theme.dart';
import 'package:instrumento/config/routes/app_router.dart';

void main() {
  // Inicializar la localización en español antes de ejecutar la app
  initializeDateFormatting('es_ES', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reloj Vital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: AppColors.background,
      ),
      routerConfig: appRouter,
    );
  }
}
