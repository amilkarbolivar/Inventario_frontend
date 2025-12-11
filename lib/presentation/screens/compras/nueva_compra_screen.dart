import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/compra_model.dart';
import '../../../data/models/producto_model.dart';
import '../../providers/compra_provider.dart';
import '../../providers/producto_provider.dart';
import '../../providers/proveedor_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';

class NuevaCompraScreen extends StatefulWidget {
  const NuevaCompraScreen({Key? key}) : super(key: key);

  @override
  State<NuevaCompraScreen> createState() => _NuevaCompraScreenState();
}

class _NuevaCompraScreenState extends State<NuevaCompraScreen> {
  final List<DetalleCompraItem> _items = [];
  ProductoModel? _selectedProducto;
  int? _selectedProveedorId;
  int _cantidad = 1;
  double _precioUnitario = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
      if (supermercadoId != null) {
        context.read<ProductoProvider>().fetchProductos(supermercadoId);
        context.read<ProveedorProvider>().fetchProveedores(supermercadoId);
      }
    });
  }

  double get _total {
    return _items.fold(0.0, (sum, item) => sum + (item.cantidad * item.precioUnitario));
  }

  void _addItem() {
    if (_selectedProducto == null || _precioUnitario <= 0) return;

    setState(() {
      final existingIndex = _items.indexWhere(
        (item) => item.productoId == _selectedProducto!.id,
      );

      if (existingIndex >= 0) {
        _items[existingIndex].cantidad += _cantidad;
      } else {
        _items.add(DetalleCompraItem(
          productoId: _selectedProducto!.id!,
          productoNombre: _selectedProducto!.nombre,
          cantidad: _cantidad,
          precioUnitario: _precioUnitario,
        ));
      }

      _selectedProducto = null;
      _cantidad = 1;
      _precioUnitario = 0.0;
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

    if (_selectedProveedorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un proveedor')),
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

    final compra = CompraModel(
      total: _total,
      administradorId: administradorId,
      provedorId: _selectedProveedorId!,
      supermercadoId: supermercadoId,
      tipoPagoId: 1, // Efectivo por defecto
      detalles: _items.map((item) => DetalleCompraModel(
        productoId: item.productoId,
        cantidad: item.cantidad,
        precioUnitario: item.precioUnitario,
      )).toList(),
    );

    final compraProvider = context.read<CompraProvider>();
    final success = await compraProvider.createCompra(compra);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compra registrada exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(compraProvider.errorMessage ?? 'Error al registrar compra'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Compra'),
      ),
      body: Column(
        children: [
          // Formulario de selección
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Selector de proveedor
                Consumer<ProveedorProvider>(
                  builder: (context, proveedorProvider, _) {
                    return DropdownButtonFormField<int>(
                      value: _selectedProveedorId,
                      decoration: const InputDecoration(
                        labelText: 'Proveedor',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      items: proveedorProvider.proveedores.map((proveedor) {
                        return DropdownMenuItem(
                          value: proveedor.id,
                          child: Text(proveedor.nombre),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedProveedorId = value),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Selector de producto
                Consumer<ProductoProvider>(
                  builder: (context, productoProvider, _) {
                    return DropdownButtonFormField<ProductoModel>(
                      value: _selectedProducto,
                      decoration: const InputDecoration(
                        labelText: 'Producto',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.inventory_2),
                      ),
                      items: productoProvider.productos
                          .where((p) => p.activo)
                          .map((producto) {
                        return DropdownMenuItem(
                          value: producto,
                          child: Text(producto.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProducto = value;
                          if (value != null) {
                            _precioUnitario = value.precio;
                          }
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Cantidad y Precio
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: _cantidad.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.numbers),
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
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: _precioUnitario.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Precio Unitario',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final precio = double.tryParse(value);
                          if (precio != null && precio > 0) {
                            setState(() => _precioUnitario = precio);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Producto'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Lista de productos agregados
          Expanded(
            child: _items.isEmpty
                ? const Center(
                    child: Text(
                      'No hay productos agregados',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.inventory_2,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(item.productoNombre),
                          subtitle: Text(
                            '${item.cantidad} x ${CurrencyFormatter.format(item.precioUnitario)}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                CurrencyFormatter.format(item.cantidad * item.precioUnitario),
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
          
          // Total y botón de guardar
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
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Registrar Compra',
                  onPressed: _isLoading ? null : _handleSubmit,
                  isLoading: _isLoading,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetalleCompraItem {
  final int productoId;
  final String productoNombre;
  int cantidad;
  final double precioUnitario;

  DetalleCompraItem({
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
  });
}