class ProveedorModel {
  final int? id;
  final String nombre;
  final String correo;
  final String telefono;
  final int supermercadoId;
  final String? supermercadoNombre;
  
  ProveedorModel({
    this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.supermercadoId,
    this.supermercadoNombre,
  });
  
  factory ProveedorModel.fromJson(Map<String, dynamic> json) {
    return ProveedorModel(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      telefono: json['telefono'],
      supermercadoId: json['supermercadoId'],
      supermercadoNombre: json['supermercadoNombre'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'telefono': telefono,
      'supermercadoId': supermercadoId,
    };
  }
}