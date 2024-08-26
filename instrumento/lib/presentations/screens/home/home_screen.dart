import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instrumento/config/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instrumento/source/mqtt_service.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool usuarioRegistrado = false;
  double temperatura = 20.0; // Valor inicial de temperatura

  AnimationController? _controller;
  Animation<double>? _animation;

  final MqttService _mqttService = MqttService('broker.emqx.io');

  @override
  void initState() {
    super.initState();
    _loadStoredData();
    _initDataStreams();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );
  }

  Future<void> _initDataStreams() async {
    await _mqttService.ensureConnected();

    _mqttService.obtenerUsuarioRegistradoStream().listen((registrado) {
      setState(() {
        usuarioRegistrado = registrado;
      });
    });

    _mqttService.obtenerTemperaturaStream().listen((temp) {
      if (mounted) {
        setState(() {
          temperatura = temp;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      usuarioRegistrado = prefs.getBool('usuarioRegistrado') ?? false;
      temperatura = prefs.getDouble('temperatura') ?? 20.0;
    });
  }

  String _getMensajeTemperatura() {
    if (temperatura < 15) {
      return "Quizás debas abrigarte para correr el día de hoy";
    } else if (temperatura >= 15 && temperatura <= 25) {
      return "Hoy es un gran día para correr";
    } else {
      return "Lleva mucha agua el día de hoy";
    }
  }

  IconData _getIconoTemperatura() {
    if (temperatura < 15) {
      return Icons.ac_unit; // Icono de frío
    } else if (temperatura >= 15 && temperatura <= 25) {
      return Icons.wb_sunny; // Icono de sol
    } else {
      return Icons.wb_iridescent; // Icono de calor
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkishWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo o Ícono con animación
          Center(
            child: ScaleTransition(
              scale: _animation!,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.softPink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Título
          const Text(
            'Reloj Vital',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Cuerpo Sano, Mente Sana',
            style: TextStyle(
              color: AppColors.softPink,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 40),
          // Información de Temperatura
          Center(
            child: Column(
              children: [
                Container(
                  width: 60, // Tamaño reducido del contorno rosa
                  height: 60, // Tamaño reducido del contorno rosa
                  decoration: BoxDecoration(
                    color: AppColors.lightPink.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconoTemperatura(),
                    color: AppColors.softPink,
                    size: 25, // Tamaño reducido del ícono
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$temperatura°C',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              _getMensajeTemperatura(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Botón de Inicio o Registro
          ElevatedButton(
            onPressed: () async {
              if (usuarioRegistrado) {
                context.go('/ritmo_cardiaco');
              } else {
                final userInfo = await context.push('/registrar_usuario');
                if (userInfo != null) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('usuarioRegistrado', true);
                  setState(() {
                    usuarioRegistrado = true;
                  });
                  context.go('/ritmo_cardiaco');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.softPink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(usuarioRegistrado ? 'Inicio' : 'Regístrate'),
          ),
        ],
      ),
    );
  }
}
