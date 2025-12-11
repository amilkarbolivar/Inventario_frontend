import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/producto_provider.dart';
import 'presentation/providers/categoria_provider.dart';
import 'presentation/providers/venta_provider.dart';
import 'presentation/providers/proveedor_provider.dart';
import 'presentation/providers/compra_provider.dart';
import 'presentation/providers/navigation_provider.dart';
import 'presentation/providers/marca_provider.dart';
import 'presentation/providers/medida_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductoProvider()),
        ChangeNotifierProvider(create: (_) => CategoriaProvider()),
        ChangeNotifierProvider(create: (_) => VentaProvider()),
        ChangeNotifierProvider(create: (_) => ProveedorProvider()),
        ChangeNotifierProvider(create: (_) => CompraProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => MarcaProvider()),
        ChangeNotifierProvider(create: (_) => MedidaProvider()),
      ],
      child: MaterialApp(
        title: 'Sistema de Inventario',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}