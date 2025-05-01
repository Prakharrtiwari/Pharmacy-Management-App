// lib/features/order/domain/entities/order.dart
class Order {
  final String id;
  final String medicineId;
  final String customerName;
  final int quantity;
  final String status;

  Order({
    required this.id,
    required this.medicineId,
    required this.customerName,
    required this.quantity,
    required this.status,
  });

  Order copyWith({
    String? id,
    String? medicineId,
    String? customerName,
    int? quantity,
    String? status,
  }) {
    return Order(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      customerName: customerName ?? this.customerName,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
    );
  }
}