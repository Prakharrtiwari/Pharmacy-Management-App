// lib/features/medicine/domain/entities/medicine.dart
class Medicine {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String expiryDate;

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.expiryDate,
  });

  // Optional: Add a copyWith method for easier updates
  Medicine copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? expiryDate,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}