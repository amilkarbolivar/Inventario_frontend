import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/proveedor_model.dart';

class ProveedorService {
  final ApiClient _client = ApiClient();
  
  Future<List<ProveedorModel>> getProveedoresBySupermercado(
    int supermercadoId,
  ) async {
    try {
      final response = await _client.get(
        ApiEndpoints.proveedoresBySupermercado(supermercadoId),
      );
      
      return (response.data as List)
          .map((json) => ProveedorModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener proveedores: $e');
    }
  }
  
  Future<ProveedorModel> createProveedor(ProveedorModel proveedor) async {
    try {
      final response = await _client.post(
        ApiEndpoints.proveedores,
        data: proveedor.toJson(),
      );
      return ProveedorModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear proveedor: $e');
    }
  }
  
  Future<ProveedorModel> updateProveedor(int id, ProveedorModel proveedor) async {
    try {
      final response = await _client.put(
        ApiEndpoints.proveedorById(id),
        data: proveedor.toJson(),
      );
      return ProveedorModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar proveedor: $e');
    }
  }
  
  Future<void> deleteProveedor(int id, int supermercadoId) async {
    try {
      await _client.delete('${ApiEndpoints.proveedores}/$id/supermercado/$supermercadoId');
    } catch (e) {
      throw Exception('Error al eliminar proveedor: $e');
    }
  }
}