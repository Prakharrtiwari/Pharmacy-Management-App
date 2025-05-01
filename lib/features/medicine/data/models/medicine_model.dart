import 'package:equatable/equatable.dart';
import 'package:pharmacy_management/features/medicine/domain/entities/medicine.dart';

class MedicineModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String expiryDate;
  final String pharmacyId;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.expiryDate,
    required this.pharmacyId,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      expiryDate: json['expiryDate'] as String? ?? '',
      pharmacyId: json['pharmacyId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'expiryDate': expiryDate,
      'pharmacyId': pharmacyId,
    };
  }

  Medicine toEntity() {
    return Medicine(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      expiryDate: expiryDate,
    );
  }

  factory MedicineModel.fromEntity(Medicine medicine, String pharmacyId) {
    return MedicineModel(
      id: medicine.id,
      name: medicine.name,
      price: medicine.price,
      quantity: medicine.quantity,
      expiryDate: medicine.expiryDate,
      pharmacyId: pharmacyId,
    );
  }

  @override
  List<Object> get props => [id, name, price, quantity, expiryDate, pharmacyId];
}