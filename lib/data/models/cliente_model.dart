class ClienteModel {
  final int? id;
  final String documentoTipo;
  final String cedula;
  final int supermercadoId;
  
  ClienteModel({
    this.id,
    required this.documentoTipo,
    required this.cedula,
    required this.supermercadoId,
  });
  
  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'],
      documentoTipo: json['documento_tipo'],
      cedula: json['cedula'],
      supermercadoId: json['supermercadoId'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'documentoTipo': documentoTipo,
      'cedula': cedula,
      'supermercadoId': supermercadoId,
    };
  }
}