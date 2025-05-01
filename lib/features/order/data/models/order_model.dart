import 'package:equatable/equatable.dart';
import 'package:pharmacy_management/features/order/domain/entities/order.dart';

class OrderModel extends Equatable {
  final String id;
  final String medicineId;
  final String customerName;
  final int quantity;
  final String status;
  final String pharmacyId;

  const OrderModel({
    required this.id,
    required this.medicineId,
    required this.customerName,
    required this.quantity,
    required this.status,
    required this.pharmacyId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      medicineId: json['medicineId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      status: json['status'] as String? ?? 'Pending',
      pharmacyId: json['pharmacyId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineId': medicineId,
      'customerName': customerName,
      'quantity': quantity,
      'status': status,
      'pharmacyId': pharmacyId,
    };
  }

  Order toEntity() {
    return Order(
      id: id,
      medicineId: medicineId,
      customerName: customerName,
      quantity: quantity,
      status: status,
    );
  }

  factory OrderModel.fromEntity(Order order, String pharmacyId) {
    return OrderModel(
      id: order.id,
      medicineId: order.medicineId,
      customerName: order.customerName,
      quantity: order.quantity,
      status: order.status,
      pharmacyId: pharmacyId,
    );
  }

  @override
  List<Object> get props => [id, medicineId, customerName, quantity, status, pharmacyId];
}