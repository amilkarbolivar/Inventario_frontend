
   import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/producto_model.dart';
import '../../../data/models/marca_model.dart';
import '../../../data/models/medida_model.dart';
import '../../providers/producto_provider.dart';
import '../../providers/categoria_provider.dart';
import '../../providers/proveedor_provider.dart';
import '../../providers/marca_provider.dart';
import '../../providers/medida_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_dropdown.dart';
import '../../widgets/common/custom_button.dart';

class ProductoFormScreen extends StatefulWidget {
  final ProductoModel? producto;

  const ProductoFormScreen({Key? key, this.producto}) : super(key: key);

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  final _codigoBarraController = TextEditingController();
  
  int? _categoriaId;
  int? _marcaId;
  int? _medidaId;
  int? _provedorId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      _nombreController.text = widget.producto!.nombre;
      _precioController.text = widget.producto!.precio.toString();
      _stockController.text = widget.producto!.stock.toString();
      _codigoBarraController.text = widget.producto!.codigoBarra;
      _categoriaId = widget.producto!.categoriaId;
      _marcaId = widget.producto!.marcaId;
      _medidaId = widget.producto!.medidaId;
      _provedorId = widget.producto!.provedorId;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
      if (supermercadoId != null) {
        context.read<CategoriaProvider>().fetchCategorias(supermercadoId);
        context.read<ProveedorProvider>().fetchProveedores(supermercadoId);
        context.read<MarcaProvider>().fetchMarcas(supermercadoId);
        context.read<MedidaProvider>().fetchMedidas(supermercadoId);
      }
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    _codigoBarraController.dispose();
    super.dispose();
  }

  Future<void> _showCreateMarcaDialog() async {
    final nombreController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Marca'),
        content: Form(
          key: formKey,
          child: CustomTextField(
            controller: nombreController,
            label: 'Nombre de la Marca',
            prefixIcon: Icons.label,
            validator: (value) => Validators.required(value, fieldName: 'Nombre'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final authProvider = context.read<AuthProvider>();
                final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
                
                if (supermercadoId != null) {
                  final marca = MarcaModel(
                    nombre: nombreController.text.trim(),
                    supermercadoId: supermercadoId,
                  );
                  
                  final success = await context.read<MarcaProvider>().createMarca(marca);
                  if (success && mounted) {
                    Navigator.pop(context, true);
                  }
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Marca creada exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _showCreateMedidaDialog() async {
    final unidadController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Medida'),
        content: Form(
          key: formKey,
          child: CustomTextField(
            controller: unidadController,
            label: 'Unidad de Medida (ej: kg, und, litro)',
            prefixIcon: Icons.straighten,
            validator: (value) => Validators.required(value, fieldName: 'Unidad'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final authProvider = context.read<AuthProvider>();
                final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
                
                if (supermercadoId != null) {
                  final medida = MedidaModel(
                    unidad: unidadController.text.trim(),
                    supermercadoId: supermercadoId,
                  );
                  
                  final success = await context.read<MedidaProvider>().createMedida(medida);
                  if (success && mounted) {
                    Navigator.pop(context, true);
                  }
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medida creada exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
    
    if (supermercadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se pudo obtener el supermercado')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final producto = ProductoModel(
      id: widget.producto?.id,
      nombre: _nombreController.text.trim(),
      precio: double.parse(_precioController.text),
      stock: int.parse(_stockController.text),
      codigoBarra: _codigoBarraController.text.trim(),
      categoriaId: _categoriaId!,
      marcaId: _marcaId!,
      medidaId: _medidaId!,
      provedorId: _provedorId!,
      supermercadoId: supermercadoId,
    );

    final productoProvider = context.read<ProductoProvider>();
    bool success;

    if (widget.producto == null) {
      success = await productoProvider.createProducto(producto);
    } else {
      success = await productoProvider.updateProducto(widget.producto!.id!, producto);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.producto == null 
              ? 'Producto creado exitosamente' 
              : 'Producto actualizado exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(productoProvider.errorMessage ?? 'Error al guardar producto'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.producto == null ? 'Nuevo Producto' : 'Editar Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nombreController,
                label: 'Nombre del Producto',
                prefixIcon: Icons.inventory,
                validator: (value) => Validators.required(value, fieldName: 'Nombre'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _precioController,
                label: 'Precio',
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: Validators.positiveNumber,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _stockController,
                label: 'Stock',
                prefixIcon: Icons.inventory_2,
                keyboardType: TextInputType.number,
                validator: (value) => Validators.positiveNumber(value, fieldName: 'Stock'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _codigoBarraController,
                label: 'Código de Barra',
                prefixIcon: Icons.qr_code,
                validator: (value) => Validators.required(value, fieldName: 'Código'),
              ),
              const SizedBox(height: 16),
              Consumer<CategoriaProvider>(
                builder: (context, categoriaProvider, _) {
                  return CustomDropdown<int>(
                    label: 'Categoría',
                    value: _categoriaId,
                    items: categoriaProvider.categorias.map((cat) {
                      return DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.nombre),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _categoriaId = value),
                    validator: (value) => value == null ? 'Selecciona una categoría' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<MarcaProvider>(
                builder: (context, marcaProvider, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: CustomDropdown<int>(
                          label: 'Marca',
                          value: _marcaId,
                          items: marcaProvider.marcas.map((marca) {
                            return DropdownMenuItem(
                              value: marca.id,
                              child: Text(marca.nombre),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => _marcaId = value),
                          validator: (value) => value == null ? 'Selecciona una marca' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: _showCreateMarcaDialog,
                          icon: const Icon(Icons.add, color: Colors.white),
                          tooltip: 'Nueva Marca',
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<MedidaProvider>(
                builder: (context, medidaProvider, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: CustomDropdown<int>(
                          label: 'Unidad de Medida',
                          value: _medidaId,
                          items: medidaProvider.medidas.map((medida) {
                            return DropdownMenuItem(
                              value: medida.id,
                              child: Text(medida.unidad),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => _medidaId = value),
                          validator: (value) => value == null ? 'Selecciona una medida' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: _showCreateMedidaDialog,
                          icon: const Icon(Icons.add, color: Colors.white),
                          tooltip: 'Nueva Medida',
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<ProveedorProvider>(
                builder: (context, proveedorProvider, _) {
                  return CustomDropdown<int>(
                    label: 'Proveedor',
                    value: _provedorId,
                    items: proveedorProvider.proveedores.map((prov) {
                      return DropdownMenuItem(
                        value: prov.id,
                        child: Text(prov.nombre),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _provedorId = value),
                    validator: (value) => value == null ? 'Selecciona un proveedor' : null,
                  );
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: widget.producto == null ? 'Crear Producto' : 'Actualizar Producto',
                onPressed: _isLoading ? null : _handleSubmit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}