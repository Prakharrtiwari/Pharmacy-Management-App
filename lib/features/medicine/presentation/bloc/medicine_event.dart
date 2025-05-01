
import 'package:equatable/equatable.dart';
import 'package:pharmacy_management/features/medicine/data/models/medicine_model.dart';

abstract class MedicineEvent extends Equatable {
  const MedicineEvent();

  @override
  List<Object> get props => [];
}

class LoadMedicinesEvent extends MedicineEvent {}

class AddMedicineEvent extends MedicineEvent {
  final MedicineModel medicine;

  const AddMedicineEvent(this.medicine);

  @override
  List<Object> get props => [medicine];
}

class UpdateMedicineEvent extends MedicineEvent {
  final MedicineModel medicine;

  const UpdateMedicineEvent(this.medicine);

  @override
  List<Object> get props => [medicine];
}

class DeleteMedicineEvent extends MedicineEvent {
  final String id;

  const DeleteMedicineEvent(this.id);

  @override
  List<Object> get props => [id];
}