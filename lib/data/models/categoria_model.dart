class CategoriaModel {
  final int? id;
  final String nombre;
  final String descripcion;
  final int supermercadoId;
  final String? supermercadoNombre;
  
  CategoriaModel({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.supermercadoId,
    this.supermercadoNombre,
  });
  
  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      supermercadoId: json['supermercadoId'],
      supermercadoNombre: json['supermercadoNombre'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'supermercadoId': supermercadoId,
    };
  }
}