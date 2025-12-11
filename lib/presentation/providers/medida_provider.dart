import 'package:flutter/material.dart';
import '../../data/services/medida_service.dart';
import '../../data/models/medida_model.dart';

class MedidaProvider extends ChangeNotifier {
  final MedidaService _medidaService = MedidaService();
  
  List<MedidaModel> _medidas = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<MedidaModel> get medidas => _medidas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchMedidas(int supermercadoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _medidas = await _medidaService.getMedidasBySupermercado(supermercadoId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createMedida(MedidaModel medida) async {
    try {
      final newMedida = await _medidaService.createMedida(medida);
      _medidas.add(newMedida);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateMedida(int id, MedidaModel medida) async {
    try {
      final updatedMedida = await _medidaService.updateMedida(id, medida);
      final index = _medidas.indexWhere((m) => m.id == id);
      if (index != -1) {
        _medidas[index] = updatedMedida;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteMedida(int id) async {
    try {
      await _medidaService.deleteMedida(id);
      _medidas.removeWhere((m) => m.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}