import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:instrumento/config/theme/app_theme.dart';
import 'package:instrumento/config/routes/app_router.dart';
import 'package:instrumento/source/mqtt_service.dart';

void main() {
  initializeDateFormatting('es_ES', null).then((_) {
    final mqttService = MqttService('broker.emqx.io');

    // Escuchar el stream de usuario registrado
    mqttService.obtenerUsuarioRegistradoStream().listen((usuario) {
      print('Usuario registrado: $usuario');
    });

    // Escuchar el stream de temperatura
    mqttService.obtenerTemperaturaStream().listen((temperatura) {
      print('Temperatura: $temperatura');
    });

    mqttService.obtenerDatosActividadFisicaStream().listen((datos) {
      print('Datos: $datos');
    });
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
