import 'package:flutter/material.dart';
import '../../data/services/marca_service.dart';
import '../../data/models/marca_model.dart';

class MarcaProvider extends ChangeNotifier {
  final MarcaService _marcaService = MarcaService();
  
  List<MarcaModel> _marcas = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<MarcaModel> get marcas => _marcas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchMarcas(int supermercadoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _marcas = await _marcaService.getMarcasBySupermercado(supermercadoId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createMarca(MarcaModel marca) async {
    try {
      final newMarca = await _marcaService.createMarca(marca);
      _marcas.add(newMarca);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateMarca(int id, MarcaModel marca) async {
    try {
      final updatedMarca = await _marcaService.updateMarca(id, marca);
      final index = _marcas.indexWhere((m) => m.id == id);
      if (index != -1) {
        _marcas[index] = updatedMarca;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteMarca(int id) async {
    try {
      await _marcaService.deleteMarca(id);
      _marcas.removeWhere((m) => m.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}