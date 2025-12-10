import 'package:flutter/material.dart';
import '../../data/services/proveedor_service.dart';
import '../../data/models/proveedor_model.dart';

class ProveedorProvider extends ChangeNotifier {
  final ProveedorService _proveedorService = ProveedorService();
  
  List<ProveedorModel> _proveedores = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<ProveedorModel> get proveedores => _proveedores;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchProveedores(int supermercadoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _proveedores = await _proveedorService.getProveedoresBySupermercado(supermercadoId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createProveedor(ProveedorModel proveedor) async {
    try {
      final newProveedor = await _proveedorService.createProveedor(proveedor);
      _proveedores.add(newProveedor);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateProveedor(int id, ProveedorModel proveedor) async {
    try {
      final updatedProveedor = await _proveedorService.updateProveedor(id, proveedor);
      final index = _proveedores.indexWhere((p) => p.id == id);
      if (index != -1) {
        _proveedores[index] = updatedProveedor;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteProveedor(int id, int supermercadoId) async {
    try {
      await _proveedorService.deleteProveedor(id, supermercadoId);
      _proveedores.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}