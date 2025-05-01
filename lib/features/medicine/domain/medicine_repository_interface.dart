import 'package:pharmacy_management/features/medicine/data/models/medicine_model.dart';

abstract class MedicineRepositoryInterface {
  Future<void> addMedicine(MedicineModel medicine, String pharmacyId);
  Future<void> updateMedicine(MedicineModel medicine, String pharmacyId);
  Future<void> deleteMedicine(String id, String pharmacyId);
  Stream<List<MedicineModel>> getMedicines(String pharmacyId);
}