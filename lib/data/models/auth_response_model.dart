class AuthResponseModel {
  final String token;
  final String tipo;
  final AdministradorModel administrador;
  
  AuthResponseModel({
    required this.token,
    required this.tipo,
    required this.administrador,
  });
  
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      tipo: json['tipo'] ?? 'Bearer',
      administrador: AdministradorModel.fromJson(json['administrador']),
    );
  }
}

class AdministradorModel {
  final int id;
  final String nombre;
  final String correo;
  final String rol;
  final bool activo;
  final int supermercadoId;
  final String supermercadoNombre;
  
  AdministradorModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.activo,
    required this.supermercadoId,
    required this.supermercadoNombre,
  });
  
  factory AdministradorModel.fromJson(Map<String, dynamic> json) {
    return AdministradorModel(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      rol: json['rol'],
      activo: json['activo'] ?? true,
      supermercadoId: json['supermercadoId'],
      supermercadoNombre: json['supermercadoNombre'] ?? '',
    );
  }
}