import 'package:flutter/material.dart';
import '../core/constants/app_routes.dart';
import '../presentation/screens/auth/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/main/main_screen.dart';
import '../presentation/screens/productos/productos_screen.dart';
import '../presentation/screens/categorias/categorias_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      
      case AppRoutes.productos:
        return MaterialPageRoute(builder: (_) => const ProductosScreen());
      
      case AppRoutes.categorias:
        return MaterialPageRoute(builder: (_) => const CategoriasScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
