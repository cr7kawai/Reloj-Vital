import 'package:flutter/material.dart';
import 'package:instrumento/presentations/screens/usuario/info_usuario_screen.dart';
import 'package:intl/intl.dart';
import 'package:instrumento/config/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE d MMMM', 'es_ES').format(now);

    return AppBar(
      backgroundColor: AppColors.lightPink, // Aplicar el color directamente
      elevation: 4,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return InfoUsuarioScreen(); // Pasar userInfo aquí
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
