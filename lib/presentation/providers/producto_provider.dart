import 'package:flutter/material.dart';
import '../../data/services/producto_service.dart';
import '../../data/models/producto_model.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoService _productoService = ProductoService();
  
  List<ProductoModel> _productos = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<ProductoModel> get productos => _productos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchProductos(int supermercadoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _productos = await _productoService.getProductosActivos(supermercadoId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createProducto(ProductoModel producto) async {
    try {
      final newProducto = await _productoService.createProducto(producto);
      _productos.add(newProducto);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateProducto(int id, ProductoModel producto) async {
    try {
      final updatedProducto = await _productoService.updateProducto(id, producto);
      final index = _productos.indexWhere((p) => p.id == id);
      if (index != -1) {
        _productos[index] = updatedProducto;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteProducto(int id) async {
    try {
      await _productoService.deleteProducto(id);
      _productos.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}