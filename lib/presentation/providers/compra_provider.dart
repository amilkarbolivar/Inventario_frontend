import 'package:flutter/material.dart';
import '../../data/services/compra_service.dart';
import '../../data/models/compra_model.dart';

class CompraProvider extends ChangeNotifier {
  final CompraService _compraService = CompraService();
  
  List<CompraModel> _compras = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<CompraModel> get compras => _compras;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchCompras(int supermercadoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _compras = await _compraService.getComprasBySupermercado(supermercadoId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createCompra(CompraModel compra) async {
    try {
      final newCompra = await _compraService.createCompra(compra);
      _compras.insert(0, newCompra);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
