import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instrumento/config/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Verificar si el usuario está registrado
    bool usuarioRegistrado = false; // Aquí se realizaría la comprobación real

    return Scaffold(
      backgroundColor: AppColors.pinkishWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo o Ícono
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.softPink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          SizedBox(height: 40),
          // Título
          Text(
            'Reloj Vital',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Cuerpo Sano, Mente Sana',
            style: TextStyle(
              color: AppColors.softPink,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 40),
          // Botón de Inicio o Registro
          ElevatedButton(
            onPressed: () async {
              if (usuarioRegistrado) {
                context.go('/ritmo_cardiaco');
              } else {
                final userInfo = await context.push('/registrar_usuario');
                if (userInfo != null) {
                  // Aquí se debería guardar la información del usuario en el sistema
                  context.go('/ritmo_cardiaco');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.softPink,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
