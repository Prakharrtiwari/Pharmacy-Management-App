import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy_management/core/constants/constants.dart';
import 'package:pharmacy_management/features/medicine/data/models/medicine_model.dart';
import 'package:pharmacy_management/features/medicine/domain/medicine_repository_interface.dart';

class MedicineRepository implements MedicineRepositoryInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addMedicine(MedicineModel medicine, String pharmacyId) async {
    try {
      await _firestore
          .collection(Constants.medicineCollection)
          .doc(medicine.id)
          .set({
        ...medicine.toJson(),
        'pharmacyId': pharmacyId,
      });
    } catch (e) {
      throw Exception('Error adding medicine: $e');
    }
  }

  @override
  Future<void> deleteMedicine(String id, String pharmacyId) async {
    try {
      await _firestore
          .collection(Constants.medicineCollection)
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Error deleting medicine: $e');
    }
  }

  @override
  Stream<List<MedicineModel>> getMedicines(String pharmacyId) {
    return _firestore
        .collection(Constants.medicineCollection)
        .where('pharmacyId', isEqualTo: pharmacyId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => MedicineModel.fromJson(doc.data()))
          .toList(),
    );
  }

  @override
  Future<void> updateMedicine(MedicineModel medicine, String pharmacyId) async {
    try {
      await _firestore
          .collection(Constants.medicineCollection)
          .doc(medicine.id)
          .update({
        ...medicine.toJson(),
        'pharmacyId': pharmacyId,
      });
    } catch (e) {
      throw Exception('Error updating medicine: $e');
    }
  }
}