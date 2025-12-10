class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Auth
  static const String login = '/auth/login';
  
  // Productos
  static const String productos = '/producto';
  static String productoById(int id) => '/producto/$id';
  static String productosActivos(int supermercadoId) => 
      '/producto/supermercado/$supermercadoId/activos';
  
  // Categorías
  static const String categorias = '/categoria';
  static String categoriaById(int id) => '/categoria/$id';
  static String categoriasBySupermercado(int supermercadoId) => 
      '/categoria/supermercado/$supermercadoId';
  
  // Proveedores
  static const String proveedores = '/proveedor';
  static String proveedorById(int id) => '/proveedor/$id';
  static String proveedoresBySupermercado(int supermercadoId) => 
      '/proveedor/supermercado/$supermercadoId';
  
  // Ventas
  static const String ventas = '/ventas';
  static String ventaById(int id) => '/ventas/$id';
  static String ventasBySupermercado(int supermercadoId) => 
      '/ventas/supermercado/$supermercadoId';
  
  // Compras
  static const String compras = '/compras';
  static String compraById(int id) => '/compras/$id';
  
  // Clientes
  static const String clientes = '/cliente';
  static String clienteById(int id) => '/cliente/$id';
}