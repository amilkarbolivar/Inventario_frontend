class MedidaModel {
  final int? id;
  final String unidad;

  MedidaModel({
    this.id,
    required this.unidad,
  });

  factory MedidaModel.fromJson(Map<String, dynamic> json) {
    return MedidaModel(
      id: json['id'],
      unidad: json['unidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unidad': unidad,
    };
  }
}
