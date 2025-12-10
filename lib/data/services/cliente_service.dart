import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/cliente_model.dart';

class ClienteService {
  final ApiClient _client = ApiClient();
  
  Future<List<ClienteModel>> getClientesBySupermercado(
    int supermercadoId,
  ) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.clientes}/supermercado/$supermercadoId',
      );
      
      return (response.data as List)
          .map((json) => ClienteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener clientes: $e');
    }
  }
  
  Future<ClienteModel> createCliente(ClienteModel cliente) async {
    try {
      final response = await _client.post(
        ApiEndpoints.clientes,
        data: cliente.toJson(),
      );
      return ClienteModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear cliente: $e');
    }
  }
}