import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../providers/producto_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/cards/producto_card.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({Key? key}) : super(key: key);

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProductos();
    });
  }

  Future<void> _loadProductos() async {
    final authProvider = context.read<AuthProvider>();
    final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
    if (supermercadoId != null) {
      await context.read<ProductoProvider>().fetchProductos(supermercadoId);
    }
  }

  Future<void> _deleteProducto(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Estás seguro de eliminar este producto?'),
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
      final success = await context.read<ProductoProvider>().deleteProducto(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto eliminado'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProductos,
        child: Consumer<ProductoProvider>(
          builder: (context, productoProvider, _) {
            if (productoProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (productoProvider.productos.isEmpty) {
              return const Center(
                child: Text('No hay productos disponibles'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: productoProvider.productos.length,
              itemBuilder: (context, index) {
                final producto = productoProvider.productos[index];
                return ProductoCard(
                  producto: producto,
                  onEdit: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productoForm,
                      arguments: producto,
                    ).then((_) => _loadProductos());
                  },
                  onDelete: () => _deleteProducto(producto.id!),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.productoForm)
              .then((_) => _loadProductos());
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}