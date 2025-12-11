class MedidaModel {
  final int? id;
  final String unidad;
  final int supermercadoId;
  final String? supermercadoNombre;
  
  MedidaModel({
    this.id,
    required this.unidad,
    required this.supermercadoId,
    this.supermercadoNombre,
  });
  
  factory MedidaModel.fromJson(Map<String, dynamic> json) {
    return MedidaModel(
      id: json['id'],
      unidad: json['unidad'],
      supermercadoId: json['supermercadoId'],
      supermercadoNombre: json['supermercadoNombre'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'unidad': unidad,
      'supermercadoId': supermercadoId,
    };
  }
}