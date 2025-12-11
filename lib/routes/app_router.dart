import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/ventas/ventas_screen.dart';
import '../core/constants/app_routes.dart';
import '../presentation/screens/auth/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/main/main_screen.dart';
import '../presentation/screens/productos/productos_screen.dart';
import '../presentation/screens/productos/producto_form_screen.dart';
import '../presentation/screens/categorias/categorias_screen.dart';
import '../presentation/screens/proveedores/proveedores_screen.dart';
import '../presentation/screens/proveedores/proveedor_form_screen.dart';
import '../presentation/screens/ventas/nueva_venta_screen.dart';
import '../presentation/screens/ventas/ventas_screen.dart';
import '../presentation/screens/compras/compras_screen.dart';
import '../presentation/screens/clientes/clientes_screen.dart';

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
      
      case AppRoutes.productoForm:
        final producto = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ProductoFormScreen(
            producto: producto as dynamic,
          ),
        );
      
      case AppRoutes.categorias:
        return MaterialPageRoute(builder: (_) => const CategoriasScreen());
      
      case AppRoutes.proveedores:
        return MaterialPageRoute(builder: (_) => const ProveedoresScreen());
      
      case AppRoutes.nuevaVenta:
        return MaterialPageRoute(builder: (_) => const NuevaVentaScreen());
      
      case AppRoutes.compras:
        return MaterialPageRoute(builder: (_) => const ComprasScreen());
      
      case AppRoutes.clientes:
        return MaterialPageRoute(builder: (_) => const ClientesScreen());
      
      case AppRoutes.ventas:
        return MaterialPageRoute(builder: (_) => const VentasScreen());
      
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