import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: const Center(
        child: Text('Pantalla de Clientes'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Cliente'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
