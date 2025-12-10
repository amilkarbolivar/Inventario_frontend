import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/producto_model.dart';

class ProductoService {
  final ApiClient _client = ApiClient();
  
  Future<List<ProductoModel>> getProductosActivos(int supermercadoId) async {
    try {
      final response = await _client.get(
        ApiEndpoints.productosActivos(supermercadoId),
      );
      
      return (response.data as List)
          .map((json) => ProductoModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener productos: $e');
    }
  }
  
  Future<ProductoModel> getProductoById(int id) async {
    try {
      final response = await _client.get(ApiEndpoints.productoById(id));
      return ProductoModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener producto: $e');
    }
  }
  
  Future<ProductoModel> createProducto(ProductoModel producto) async {
    try {
      final response = await _client.post(
        ApiEndpoints.productos,
        data: producto.toJson(),
      );
      return ProductoModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear producto: $e');
    }
  }
  
  Future<ProductoModel> updateProducto(int id, ProductoModel producto) async {
    try {
      final response = await _client.put(
        ApiEndpoints.productoById(id),
        data: producto.toJson(),
      );
      return ProductoModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }
  
  Future<void> deleteProducto(int id) async {
    try {
      await _client.delete(ApiEndpoints.productoById(id));
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }
}
