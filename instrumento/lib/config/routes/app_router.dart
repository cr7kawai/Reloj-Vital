import 'package:go_router/go_router.dart';
import 'package:instrumento/presentations/screens/actividad_fisica/actividad_fisica_screen.dart';
import 'package:instrumento/presentations/screens/home/home_screen.dart';
import 'package:instrumento/presentations/screens/ritmo_cardiaco/ritmo_cardiaco_screen.dart';
import 'package:instrumento/presentations/screens/usuario/registro_usuario_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/ritmo_cardiaco',
      name: RitmoCardiacoScreen.name,
      builder: (context, state) => const RitmoCardiacoScreen(),
    ),
    GoRoute(
      path: '/actividad_fisica',
      name: ActividadFisicaScreen.name,
      builder: (context, state) => const ActividadFisicaScreen(),
    ),
    GoRoute(
      path: '/registrar_usuario',
      name: RegistrarUsuarioScreen.name,
      builder: (context, state) => const RegistrarUsuarioScreen(),
    ),
  ],
);
