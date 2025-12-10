class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Auth
  static const String login = '/auth/login';
  
  // Productos
  static const String productos = '/productos';
  static String productoById(int id) => '/productos/$id';
  static String productosActivos(int supermercadoId) => 
      '/productos/supermercado/$supermercadoId/activos';
  
  // Categorías
  static const String categorias = '/categorias';
  static String categoriaById(int id) => '/categorias/$id';
  static String categoriasBySupermercado(int supermercadoId) => 
      '/categorias/supermercado/$supermercadoId';
  
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