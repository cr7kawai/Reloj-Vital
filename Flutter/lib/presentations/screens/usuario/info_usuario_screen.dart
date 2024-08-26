import 'package:flutter/material.dart';
import 'package:instrumento/config/theme/app_theme.dart';
import 'package:instrumento/source/mqtt_service.dart';

class InfoUsuarioScreen extends StatefulWidget {
  const InfoUsuarioScreen({super.key});

  static const String name = 'InfoUsuarioScreen';

  @override
  _InfoUsuarioScreenState createState() => _InfoUsuarioScreenState();
}

class _InfoUsuarioScreenState extends State<InfoUsuarioScreen> {
  late MqttService _mqttService;
  Map<String, dynamic> _userInfo = {
    'name': 'No especificado',
    'sex': 'No especificado',
    'height': 'No especificado',
    'weight': 'No especificado',
    'goal': 'No especificado'
  };

  @override
  void initState() {
    super.initState();
    _mqttService = MqttService('broker.emqx.io');
    _initDataStream();
  }

  Future<void> _initDataStream() async {
    await _mqttService.ensureConnected();

    _mqttService.obtenerInfoUsuarioStream().listen((data) {
      if (data['registrado'] == true) {
        setState(() {
          _userInfo = {
            'name': data['nombre'] ?? 'No especificado',
            'sex': data['sexo'] ?? 'Masculino',
            'height': '${data['estatura'] ?? 'No especificado'} cm',
            'weight': '${data['peso'] ?? 'No especificado'} kg',
            'goal': '${data['meta'] ?? 'No especificado'} KCAL/DÍA'
          };
        });
      } else {
        setState(() {
          _userInfo = {
            'name': 'No especificado',
            'sex': 'No especificado',
            'height': 'No especificado',
            'weight': 'No especificado',
            'goal': 'No especificado'
          };
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: AppColors.lightPink,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo('Nombre', _userInfo['name']),
              const SizedBox(height: 10),
              _buildUserInfo('Sexo', _userInfo['sex']),
              const SizedBox(height: 10),
              _buildUserInfo('Estatura', _userInfo['height']),
              const SizedBox(height: 10),
              _buildUserInfo('Peso', _userInfo['weight']),
              const SizedBox(height: 20),
              const Text(
                'Objetivo',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              _buildUserInfo('Actividad Física', _userInfo['goal']),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
