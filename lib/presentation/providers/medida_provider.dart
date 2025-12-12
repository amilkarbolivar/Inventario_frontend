import 'package:flutter/material.dart';
import '../../data/models/medida_model.dart';
import '../../data/services/medida_service.dart';

class MedidaProvider extends ChangeNotifier {
  final MedidaService _service = MedidaService();

  List<MedidaModel> _medidas = [];
  List<MedidaModel> get medidas => _medidas;

  Future<void> fetchMedidas() async {
    try {
      print("DEBUG: Cargando medidas...");
      _medidas = await _service.getMedidas();
      print("DEBUG: Medidas cargadas: $_medidas");
      notifyListeners();
    } catch (e) {
      print("Error al cargar medidas: $e");
    }
  }

  Future<bool> addMedida(MedidaModel medida) async {
    try {
      final nueva = await _service.createMedida(medida);
      _medidas.add(nueva);
      notifyListeners();
      return true;
    } catch (e) {
      print("Error al agregar medida: $e");
      return false;
    }
  }

  Future<bool> updateMedida(MedidaModel medida) async {
    try {
      final updated = await _service.updateMedida(medida.id!, medida);
      final index = _medidas.indexWhere((m) => m.id == medida.id);

      if (index != -1) {
        _medidas[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      print("Error al actualizar medida: $e");
      return false;
    }
  }

  Future<bool> deleteMedida(int id) async {
    try {
      await _service.deleteMedida(id);
      _medidas.removeWhere((m) => m.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      print("Error al eliminar medida: $e");
      return false;
    }
  }
}
