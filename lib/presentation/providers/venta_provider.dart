import 'package:flutter/material.dart';
import '../../data/services/venta_service.dart';
import '../../data/models/venta_model.dart';

class VentaProvider extends ChangeNotifier {
  final VentaService _ventaService = VentaService();
  
  List<VentaModel> _ventas = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<VentaModel> get ventas => _ventas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchVentas(int supermercadoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _ventas = await _ventaService.getVentasBySupermercado(supermercadoId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createVenta(VentaModel venta) async {
    try {
      final newVenta = await _ventaService.createVenta(venta);
      _ventas.insert(0, newVenta);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
