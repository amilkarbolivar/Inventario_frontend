import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/producto_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/cards/producto_card.dart';

class ProductosScreen extends StatelessWidget {
  const ProductosScreen({Key? key}) : super(key: key);

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
      body: Consumer2<ProductoProvider, AuthProvider>(
        builder: (context, productoProvider, authProvider, _) {
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
              return ProductoCard(producto: producto);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a formulario de nuevo producto
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}