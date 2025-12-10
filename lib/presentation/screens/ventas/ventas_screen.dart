import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/venta_provider.dart';
import '../../providers/auth_provider.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({Key? key}) : super(key: key);

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVentas();
    });
  }

  Future<void> _loadVentas() async {
    final authProvider = context.read<AuthProvider>();
    final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
    if (supermercadoId != null) {
      await context.read<VentaProvider>().fetchVentas(supermercadoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadVentas,
        child: Consumer<VentaProvider>(
          builder: (context, ventaProvider, _) {
            if (ventaProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (ventaProvider.ventas.isEmpty) {
              return const Center(
                child: Text('No hay ventas registradas'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ventaProvider.ventas.length,
              itemBuilder: (context, index) {
                final venta = ventaProvider.ventas[index];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Venta #${venta.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              venta.tipoPagoNombre ?? 'Efectivo',
                              style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        CurrencyFormatter.format(venta.total),
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        venta.fecha != null
                            ? DateFormatter.format(DateTime.parse(venta.fecha!))
                            : 'Sin fecha',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      if (venta.clienteCedula != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Cliente: ${venta.clienteCedula}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.nuevaVenta)
              .then((_) => _loadVentas());
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Nueva Venta'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}