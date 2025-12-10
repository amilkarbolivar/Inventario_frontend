import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/venta_model.dart';
import '../../../data/models/producto_model.dart';
import '../../providers/venta_provider.dart';
import '../../providers/producto_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';

class NuevaVentaScreen extends StatefulWidget {
  const NuevaVentaScreen({Key? key}) : super(key: key);

  @override
  State<NuevaVentaScreen> createState() => _NuevaVentaScreenState();
}

class _NuevaVentaScreenState extends State<NuevaVentaScreen> {
  final List<DetalleVentaItem> _items = [];
  ProductoModel? _selectedProducto;
  int _cantidad = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
      if (supermercadoId != null) {
        context.read<ProductoProvider>().fetchProductos(supermercadoId);
      }
    });
  }

  double get _total {
    return _items.fold(0.0, (sum, item) => sum + (item.cantidad * item.precio));
  }

  void _addItem() {
    if (_selectedProducto == null) return;

    setState(() {
      final existingIndex = _items.indexWhere(
        (item) => item.productoId == _selectedProducto!.id,
      );

      if (existingIndex >= 0) {
        _items[existingIndex].cantidad += _cantidad;
      } else {
        _items.add(DetalleVentaItem(
          productoId: _selectedProducto!.id!,
          productoNombre: _selectedProducto!.nombre,
          cantidad: _cantidad,
          precio: _selectedProducto!.precio,
        ));
      }

      _selectedProducto = null;
      _cantidad = 1;
    });
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  Future<void> _handleSubmit() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un producto')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final administradorId = authProvider.authResponse?.administrador.id;
    final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;

    if (administradorId == null || supermercadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Datos de usuario no disponibles')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final venta = VentaModel(
      total: _total,
      administradorId: administradorId,
      supermercadoId: supermercadoId,
      tipoPagoId: 1, // Efectivo por defecto
      detalles: _items.map((item) => DetalleVentaModel(
        productoId: item.productoId,
        cantidad: item.cantidad,
        precioDetalle: item.precio,
      )).toList(),
    );

    final ventaProvider = context.read<VentaProvider>();
    final success = await ventaProvider.createVenta(venta);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Venta registrada exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ventaProvider.errorMessage ?? 'Error al registrar venta'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Venta'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Consumer<ProductoProvider>(
                  builder: (context, productoProvider, _) {
                    return DropdownButtonFormField<ProductoModel>(
                      value: _selectedProducto,
                      decoration: const InputDecoration(
                        labelText: 'Seleccionar Producto',
                        border: OutlineInputBorder(),
                      ),
                      items: productoProvider.productos.map((producto) {
                        return DropdownMenuItem(
                          value: producto,
                          child: Text('${producto.nombre} - ${CurrencyFormatter.format(producto.precio)}'),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedProducto = value),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _cantidad.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final cantidad = int.tryParse(value);
                          if (cantidad != null && cantidad > 0) {
                            setState(() => _cantidad = cantidad);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _addItem,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('No hay productos agregados'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.productoNombre),
                          subtitle: Text('${item.cantidad} x ${CurrencyFormatter.format(item.precio)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                CurrencyFormatter.format(item.cantidad * item.precio),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: AppColors.error),
                                onPressed: () => _removeItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(_total),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Finalizar Venta',
                  onPressed: _isLoading ? null : _handleSubmit,
                  isLoading: _isLoading,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetalleVentaItem {
  final int productoId;
  final String productoNombre;
  int cantidad;
  final double precio;

  DetalleVentaItem({
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.precio,
  });
}