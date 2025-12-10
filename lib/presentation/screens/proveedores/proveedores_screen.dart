import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/proveedores/proveedor_form_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
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
      _loadProveedores();
    });
  }

  Future<void> _loadProveedores() async {
    final authProvider = context.read<AuthProvider>();
    final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
    if (supermercadoId != null) {
      await context.read<ProveedorProvider>().fetchProveedores(supermercadoId);
    }
  }

  Future<void> _deleteProveedor(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Estás seguro de eliminar este proveedor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final authProvider = context.read<AuthProvider>();
      final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
      if (supermercadoId != null) {
        final success = await context.read<ProveedorProvider>()
            .deleteProveedor(id, supermercadoId);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proveedor eliminado'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProveedores,
        child: Consumer<ProveedorProvider>(
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProveedorFormScreen(),
            ),
          ).then((_) => _loadProveedores());
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Proveedor'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}