import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/categoria_provider.dart';
import '../../providers/auth_provider.dart';
import 'categoria_form_dialog.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({Key? key}) : super(key: key);

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategorias();
    });
  }

  Future<void> _loadCategorias() async {
    final authProvider = context.read<AuthProvider>();
    final supermercadoId = authProvider.authResponse?.administrador.supermercadoId;
    if (supermercadoId != null) {
      await context.read<CategoriaProvider>().fetchCategorias(supermercadoId);
    }
  }

  void _showCategoriaDialog() {
    showDialog(
      context: context,
      builder: (context) => const CategoriaFormDialog(),
    ).then((_) => _loadCategorias());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadCategorias,
        child: Consumer<CategoriaProvider>(
          builder: (context, categoriaProvider, _) {
            if (categoriaProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (categoriaProvider.categorias.isEmpty) {
              return const Center(
                child: Text('No hay categorías registradas'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categoriaProvider.categorias.length,
              itemBuilder: (context, index) {
                final categoria = categoriaProvider.categorias[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                        categoria.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categoria.descripcion,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCategoriaDialog,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Categoría'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
