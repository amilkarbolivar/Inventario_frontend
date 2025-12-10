import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/categoria_model.dart';

class CategoriaService {
  final ApiClient _client = ApiClient();
  
  Future<List<CategoriaModel>> getCategoriasBySupermercado(
    int supermercadoId,
  ) async {
    try {
      final response = await _client.get(
        ApiEndpoints.categoriasBySupermercado(supermercadoId),
      );
      
      return (response.data as List)
          .map((json) => CategoriaModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener categorías: $e');
    }
  }
  
  Future<CategoriaModel> createCategoria(CategoriaModel categoria) async {
    try {
      final response = await _client.post(
        ApiEndpoints.categorias,
        data: categoria.toJson(),
      );
      return CategoriaModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear categoría: $e');
    }
  }
}