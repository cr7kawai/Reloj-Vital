import 'package:flutter/material.dart';
import 'package:instrumento/config/theme/app_theme.dart';

class InfoUsuarioScreen extends StatelessWidget {
  final Map<String, String> userInfo;

  const InfoUsuarioScreen({Key? key, required this.userInfo}) : super(key: key);

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
              _buildUserInfo('Nombre', userInfo['name'] ?? 'No especificado'),
              const SizedBox(height: 10),
              _buildUserInfo('Sexo', userInfo['sex'] ?? 'No especificado'),
              const SizedBox(height: 10),
              _buildUserInfo(
                  'Estatura', userInfo['height'] ?? 'No especificado'),
              const SizedBox(height: 10),
              _buildUserInfo('Peso', userInfo['weight'] ?? 'No especificado'),
              const SizedBox(height: 20),
              const Text(
                'Objetivo',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              _buildUserInfo(
                  'Actividad Física', userInfo['goal'] ?? 'No especificado'),
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
