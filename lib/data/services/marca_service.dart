import '../../core/network/api_client.dart';
import '../models/marca_model.dart';

class MarcaService {
  final ApiClient _client = ApiClient();
  
  Future<List<MarcaModel>> getMarcasBySupermercado(int supermercadoId) async {
    try {
      final response = await _client.get(
        '/marca/supermercado/$supermercadoId',
      );
      
      return (response.data as List)
          .map((json) => MarcaModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener marcas: $e');
    }
  }
  
  Future<MarcaModel> createMarca(MarcaModel marca) async {
    try {
      final response = await _client.post(
        '/marca',
        data: marca.toJson(),
      );
      return MarcaModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear marca: $e');
    }
  }
  
  Future<MarcaModel> updateMarca(int id, MarcaModel marca) async {
    try {
      final response = await _client.put(
        '/marca/$id',
        data: marca.toJson(),
      );
      return MarcaModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar marca: $e');
    }
  }
  
  Future<void> deleteMarca(int id) async {
    try {
      await _client.delete('/marca/$id');
    } catch (e) {
      throw Exception('Error al eliminar marca: $e');
    }
  }
}