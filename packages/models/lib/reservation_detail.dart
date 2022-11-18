import 'package:equatable/equatable.dart';

class ReservationDetail extends Equatable {
  const ReservationDetail({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory ReservationDetail.fromJson(Map<String, dynamic> json, [String? id]) {
    return ReservationDetail(
      id: id ?? json['id'] as String,
      productId: json['product_Id'] as String,
      productName: json['product_name'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        quantity,
        unitPrice,
        subtotal,
      ];

  Map<String, dynamic> toJson() {
    return {
      'product_Id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
    };
  }
}
