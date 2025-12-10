class ProductoModel {
  final int? id;
  final String nombre;
  final double precio;
  final int stock;
  final String codigoBarra;
  final bool activo;
  final int categoriaId;
  final String? categoriaNombre;
  final int marcaId;
  final String? marcaNombre;
  final int medidaId;
  final String? medidaUnidad;
  final int provedorId;
  final String? provedorNombre;
  final int supermercadoId;
  final String? supermercadoNombre;
  final String? creadoEn;
  
  ProductoModel({
    this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.codigoBarra,
    this.activo = true,
    required this.categoriaId,
    this.categoriaNombre,
    required this.marcaId,
    this.marcaNombre,
    required this.medidaId,
    this.medidaUnidad,
    required this.provedorId,
    this.provedorNombre,
    required this.supermercadoId,
    this.supermercadoNombre,
    this.creadoEn,
  });
  
  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'],
      nombre: json['nombre'],
      precio: (json['precio'] as num).toDouble(),
      stock: json['stock'],
      codigoBarra: json['codigoBarra'],
      activo: json['activo'] ?? true,
      categoriaId: json['categoriaId'],
      categoriaNombre: json['categoriaNombre'],
      marcaId: json['marcaId'],
      marcaNombre: json['marcaNombre'],
      medidaId: json['medidaId'],
      medidaUnidad: json['medidaUnidad'],
      provedorId: json['provedorId'],
      provedorNombre: json['provedorNombre'],
      supermercadoId: json['supermercadoId'],
      supermercadoNombre: json['supermercadoNombre'],
      creadoEn: json['creadoEn'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'codigoBarra': codigoBarra,
      'categoriaId': categoriaId,
      'marcaId': marcaId,
      'medidaId': medidaId,
      'provedorId': provedorId,
      'supermercadoId': supermercadoId,
    };
  }
}