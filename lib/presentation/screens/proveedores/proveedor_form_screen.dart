import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/proveedor_model.dart';
import '../../providers/proveedor_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

class ProveedorFormScreen extends StatefulWidget {
  final ProveedorModel? proveedor;

  const ProveedorFormScreen({Key? key, this.proveedor}) : super(key: key);

  @override
  State<ProveedorFormScreen> createState() => _ProveedorFormScreenState();
}

class _ProveedorFormScreenState extends State<ProveedorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.proveedor != null) {
      _nombreController.text = widget.proveedor!.nombre;
      _correoController.text = widget.proveedor!.correo;
      _telefonoController.text = widget.proveedor!.telefono;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    super.dispose();
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

    final proveedor = ProveedorModel(
      id: widget.proveedor?.id,
      nombre: _nombreController.text.trim(),
      correo: _correoController.text.trim(),
      telefono: _telefonoController.text.trim(),
      supermercadoId: supermercadoId,
    );

    final proveedorProvider = context.read<ProveedorProvider>();
    bool success;

    if (widget.proveedor == null) {
      success = await proveedorProvider.createProveedor(proveedor);
    } else {
      success = await proveedorProvider.updateProveedor(widget.proveedor!.id!, proveedor);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.proveedor == null 
              ? 'Proveedor creado exitosamente' 
              : 'Proveedor actualizado exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(proveedorProvider.errorMessage ?? 'Error al guardar proveedor'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.proveedor == null ? 'Nuevo Proveedor' : 'Editar Proveedor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nombreController,
                label: 'Nombre del Proveedor',
                prefixIcon: Icons.business,
                validator: (value) => Validators.required(value, fieldName: 'Nombre'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _correoController,
                label: 'Correo Electrónico',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _telefonoController,
                label: 'Teléfono',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => Validators.required(value, fieldName: 'Teléfono'),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: widget.proveedor == null ? 'Crear Proveedor' : 'Actualizar Proveedor',
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