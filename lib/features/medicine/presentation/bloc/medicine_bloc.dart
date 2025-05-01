import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pharmacy_management/features/medicine/data/models/medicine_model.dart';
import 'package:pharmacy_management/features/medicine/data/repositories/medicine_repository.dart';

import 'medicine_event.dart';
import 'medicine_state.dart';

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository _medicineRepository;
  final String pharmacyId;

  MedicineBloc({required this.pharmacyId, MedicineRepository? medicineRepository})
      : _medicineRepository = medicineRepository ?? MedicineRepository(),
        super(MedicineInitial()) {
    on<AddMedicineEvent>((event, emit) async {
      emit(MedicineLoading());
      try {
        await _medicineRepository.addMedicine(event.medicine, pharmacyId);
        emit(MedicineSuccess());
        add(LoadMedicinesEvent());
      } catch (e) {
        emit(MedicineError(e.toString()));
      }
    });

    on<UpdateMedicineEvent>((event, emit) async {
      emit(MedicineLoading());
      try {
        await _medicineRepository.updateMedicine(event.medicine, pharmacyId);
        emit(MedicineSuccess());
        add(LoadMedicinesEvent());
      } catch (e) {
        emit(MedicineError(e.toString()));
      }
    });

    on<DeleteMedicineEvent>((event, emit) async {
      emit(MedicineLoading());
      try {
        await _medicineRepository.deleteMedicine(event.id, pharmacyId);
        emit(MedicineSuccess());
        add(LoadMedicinesEvent());
      } catch (e) {
        emit(MedicineError(e.toString()));
      }
    });

    on<LoadMedicinesEvent>((event, emit) async {
      emit(MedicineLoading());
      try {
        final stream = _medicineRepository.getMedicines(pharmacyId);
        emit(MedicineLoaded(stream));
      } catch (e) {
        emit(MedicineError(e.toString()));
      }
    });
  }
}