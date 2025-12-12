import '../../core/network/api_client.dart';
import '../models/medida_model.dart';

class MedidaService {
  final ApiClient _client = ApiClient();

  Future<List<MedidaModel>> getMedidas() async {
    try {
      final response = await _client.get('/medidas');

      print("DEBUG API /medidas → ${response.data}");

      return (response.data as List)
          .map((json) => MedidaModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener medidas: $e");
    }
  }

  Future<MedidaModel> createMedida(MedidaModel medida) async {
    try {
      final response = await _client.post('/medidas', data: medida.toJson());
      return MedidaModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error al crear medida: $e");
    }
  }

  Future<MedidaModel> updateMedida(int id, MedidaModel medida) async {
    try {
      final response =
          await _client.put('/medidas/$id', data: medida.toJson());
      return MedidaModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error al actualizar medida: $e");
    }
  }

  Future<void> deleteMedida(int id) async {
    try {
      await _client.delete('/medidas/$id');
    } catch (e) {
      throw Exception("Error al eliminar medida: $e");
    }
  }
}
