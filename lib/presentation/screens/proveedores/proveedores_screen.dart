import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/proveedor_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/cards/proveedor_card.dart';

class ProveedoresScreen extends StatefulWidget {
  const ProveedoresScreen({Key? key}) : super(key: key);

  @override
  State<ProveedoresScreen> createState() => _ProveedoresScreenState();
}

class _ProveedoresScreenState extends State<ProveedoresScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
      if (supermercadoId != null) {
        context.read<ProveedorProvider>().fetchProveedores(supermercadoId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
      ),
      body: Consumer<ProveedorProvider>(
        builder: (context, proveedorProvider, _) {
          if (proveedorProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (proveedorProvider.proveedores.isEmpty) {
            return const Center(
              child: Text('No hay proveedores registrados'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: proveedorProvider.proveedores.length,
            itemBuilder: (context, index) {
              final proveedor = proveedorProvider.proveedores[index];
              return ProveedorCard(proveedor: proveedor);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a formulario de nuevo proveedor
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Proveedor'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}