import 'package:flutter/material.dart';
import '../../data/services/categoria_service.dart';
import '../../data/models/categoria_model.dart';

class CategoriaProvider extends ChangeNotifier {
  final CategoriaService _categoriaService = CategoriaService();
  
  List<CategoriaModel> _categorias = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<CategoriaModel> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchCategorias(int supermercadoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _categorias = await _categoriaService.getCategoriasBySupermercado(supermercadoId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createCategoria(CategoriaModel categoria) async {
    try {
      final newCategoria = await _categoriaService.createCategoria(categoria);
      _categorias.add(newCategoria);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}