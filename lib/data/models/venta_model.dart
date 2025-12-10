class VentaModel {
  final int? id;
  final double total;
  final String? fecha;
  final int administradorId;
  final String? administradorNombre;
  final int? clienteId;
  final String? clienteCedula;
  final int supermercadoId;
  final String? supermercadoNombre;
  final int tipoPagoId;
  final String? tipoPagoNombre;
  final List<DetalleVentaModel> detalles;
  
  VentaModel({
    this.id,
    required this.total,
    this.fecha,
    required this.administradorId,
    this.administradorNombre,
    this.clienteId,
    this.clienteCedula,
    required this.supermercadoId,
    this.supermercadoNombre,
    required this.tipoPagoId,
    this.tipoPagoNombre,
    required this.detalles,
  });
  
  factory VentaModel.fromJson(Map<String, dynamic> json) {
    return VentaModel(
      id: json['id'],
      total: (json['total'] as num).toDouble(),
      fecha: json['fecha'],
      administradorId: json['administradorId'],
      administradorNombre: json['administradorNombre'],
      clienteId: json['clienteId'],
      clienteCedula: json['clienteCedula'],
      supermercadoId: json['supermercadoId'],
      supermercadoNombre: json['supermercadoNombre'],
      tipoPagoId: json['tipoPagoId'],
      tipoPagoNombre: json['tipoPagoNombre'],
      detalles: (json['detalles'] as List?)
          ?.map((d) => DetalleVentaModel.fromJson(d))
          .toList() ?? [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'administradorId': administradorId,
      'clienteId': clienteId,
      'supermercadoId': supermercadoId,
      'tipoPagoId': tipoPagoId,
      'total': total,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }
}

class DetalleVentaModel {
  final int? id;
  final int productoId;
  final String? productoNombre;
  final int cantidad;
  final double precioDetalle;
  final double? subtotal;
  
  DetalleVentaModel({
    this.id,
    required this.productoId,
    this.productoNombre,
    required this.cantidad,
    required this.precioDetalle,
    this.subtotal,
  });
  
  factory DetalleVentaModel.fromJson(Map<String, dynamic> json) {
    return DetalleVentaModel(
      id: json['id'],
      productoId: json['productoId'],
      productoNombre: json['productoNombre'],
      cantidad: json['cantidad'],
      precioDetalle: (json['precioDetalle'] as num).toDouble(),
      subtotal: json['subtotal'] != null 
          ? (json['subtotal'] as num).toDouble() 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'productoId': productoId,
      'cantidad': cantidad,
      'precioDetalle': precioDetalle,
    };
  }
}