import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/venta_model.dart';

class VentaService {
  final ApiClient _client = ApiClient();
  
  Future<List<VentaModel>> getVentasBySupermercado(int supermercadoId) async {
    try {
      final response = await _client.get(
        ApiEndpoints.ventasBySupermercado(supermercadoId),
      );
      
      return (response.data as List)
          .map((json) => VentaModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener ventas: $e');
    }
  }
  
  Future<VentaModel> createVenta(VentaModel venta) async {
    try {
      final response = await _client.post(
        ApiEndpoints.ventas,
        data: venta.toJson(),
      );
      return VentaModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear venta: $e');
    }
  }
}