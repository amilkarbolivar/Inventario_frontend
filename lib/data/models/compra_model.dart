class CompraModel {
  final int? id;
  final double total;
  final String? fecha;
  final int administradorId;
  final String? administradorNombre;
  final int provedorId;
  final String? provedorNombre;
  final int supermercadoId;
  final String? supermercadoNombre;
  final int tipoPagoId;
  final String? tipoPagoNombre;
  final List<DetalleCompraModel> detalles;
  
  CompraModel({
    this.id,
    required this.total,
    this.fecha,
    required this.administradorId,
    this.administradorNombre,
    required this.provedorId,
    this.provedorNombre,
    required this.supermercadoId,
    this.supermercadoNombre,
    required this.tipoPagoId,
    this.tipoPagoNombre,
    required this.detalles,
  });
  
  factory CompraModel.fromJson(Map<String, dynamic> json) {
    return CompraModel(
      id: json['id'],
      total: (json['total'] as num).toDouble(),
      fecha: json['fecha'],
      administradorId: json['administradorId'],
      administradorNombre: json['administradorNombre'],
      provedorId: json['provedorId'],
      provedorNombre: json['provedorNombre'],
      supermercadoId: json['supermercadoId'],
      supermercadoNombre: json['supermercadoNombre'],
      tipoPagoId: json['tipoPagoId'],
      tipoPagoNombre: json['tipoPagoNombre'],
      detalles: (json['detalle'] as List?)
          ?.map((d) => DetalleCompraModel.fromJson(d))
          .toList() ?? [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'administradorId': administradorId,
      'provedorId': provedorId,
      'supermercadoId': supermercadoId,
      'tipoPagoId': tipoPagoId,
      'total': total,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }
}

class DetalleCompraModel {
  final int? id;
  final int productoId;
  final String? productoNombre;
  final int cantidad;
  final double precioUnitario;
  final double? subtotal;
  
  DetalleCompraModel({
    this.id,
    required this.productoId,
    this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
    this.subtotal,
  });
  
  factory DetalleCompraModel.fromJson(Map<String, dynamic> json) {
    return DetalleCompraModel(
      id: json['id'],
      productoId: json['productoId'],
      productoNombre: json['productoNombre'],
      cantidad: json['cantidad'],
      precioUnitario: (json['precioUnitario'] as num).toDouble(),
      subtotal: json['subtotal'] != null 
          ? (json['subtotal'] as num).toDouble() 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'productoId': productoId,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
    };
  }
}