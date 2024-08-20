import 'package:flutter/material.dart';
import 'package:instrumento/config/theme/app_theme.dart';
import 'package:go_router/go_router.dart'; // Importa GoRouter para la navegación

class CustomFooter extends StatelessWidget {
  final String currentScreen;

  const CustomFooter({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: BottomAppBar(
        color: AppColors.background, // Color de fondo
        elevation: 20, // Sombra más pronunciada para un efecto de elevación
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFooterButton(
                icon: Icons.favorite,
                label: 'Ritmo',
                isSelected: currentScreen == 'Ritmo',
                onPressed: () {
                  if (currentScreen != 'Ritmo') {
                    context.go('/ritmo_cardiaco');
                  }
                },
              ),
              _buildFooterButton(
                icon: Icons.directions_walk,
                label: 'Actividad',
                isSelected: currentScreen == 'Actividad',
                onPressed: () {
                  if (currentScreen != 'Actividad') {
                    context.go('/actividad_fisica');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    final Color highlightColor = AppColors.softPink;

    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Ajuste para que no ocupe más espacio del necesario
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(2.0), // Reduce el padding
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? highlightColor.withOpacity(0.2)
                    : Colors
                        .transparent, // Fondo suave para el icono seleccionado
                border: isSelected
                    ? Border.all(color: highlightColor, width: 2)
                    : null,
              ),
              child: Icon(
                icon,
                color: isSelected ? highlightColor : AppColors.lightPink,
                size: 30, // Reducción del tamaño del icono
              ),
            ),
            const SizedBox(height: 2), // Espacio entre el icono y el texto
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? highlightColor : AppColors.lightPink,
                    fontSize: 12, // Tamaño de texto reducido
                  ),
                  overflow: TextOverflow
                      .ellipsis, // Esto asegura que el texto no desborde
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
