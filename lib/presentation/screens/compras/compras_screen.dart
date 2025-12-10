import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/compra_provider.dart';
import '../../providers/auth_provider.dart';

class ComprasScreen extends StatefulWidget {
  const ComprasScreen({Key? key}) : super(key: key);

  @override
  State<ComprasScreen> createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
      if (supermercadoId != null) {
        context.read<CompraProvider>().fetchCompras(supermercadoId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
      ),
      body: Consumer<CompraProvider>(
        builder: (context, compraProvider, _) {
          if (compraProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (compraProvider.compras.isEmpty) {
            return const Center(
              child: Text('No hay compras registradas'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: compraProvider.compras.length,
            itemBuilder: (context, index) {
              final compra = compraProvider.compras[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Proveedor: ${compra.provedorNombre ?? "N/A"}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: \$${compra.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fecha: ${compra.fecha ?? "N/A"}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nueva Compra'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}