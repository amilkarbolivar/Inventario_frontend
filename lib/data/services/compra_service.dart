import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/compra_model.dart';

class CompraService {
  final ApiClient _client = ApiClient();
  
  Future<List<CompraModel>> getComprasBySupermercado(int supermercadoId) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.compras}/supermercado/$supermercadoId',
      );
      
      return (response.data as List)
          .map((json) => CompraModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener compras: $e');
    }
  }
  
  Future<CompraModel> createCompra(CompraModel compra) async {
    try {
      final response = await _client.post(
        ApiEndpoints.compras,
        data: compra.toJson(),
      );
      return CompraModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear compra: $e');
    }
  }
}