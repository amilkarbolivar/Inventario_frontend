class MarcaModel {
  final int? id;
  final String nombre;
  final int supermercadoId;
  final String? supermercadoNombre;
  
  MarcaModel({
    this.id,
    required this.nombre,
    required this.supermercadoId,
    this.supermercadoNombre,
  });
  
  factory MarcaModel.fromJson(Map<String, dynamic> json) {
    return MarcaModel(
      id: json['id'],
      nombre: json['nombre'],
      supermercadoId: json['supermercadoId'],
      supermercadoNombre: json['supermercadoNombre'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'supermercadoId': supermercadoId,
    };
  }
}