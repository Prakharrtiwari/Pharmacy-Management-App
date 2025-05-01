import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_management/core/theme/app_theme.dart';
import 'package:pharmacy_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pharmacy_management/features/medicine/data/models/medicine_model.dart';
import 'package:pharmacy_management/features/medicine/domain/entities/medicine.dart';
import 'package:pharmacy_management/features/medicine/presentation/bloc/medicine_bloc.dart';
import 'package:pharmacy_management/features/medicine/presentation/widgets/medicine_table.dart';
import 'package:uuid/uuid.dart';

import '../bloc/medicine_event.dart';
import '../bloc/medicine_state.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _expiryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();
    _expiryController.clear();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final pharmacyId = authState.pharmacy.id; // Changed from .uid to .id
        final medicine = Medicine(
          id: const Uuid().v4(),
          name: _nameController.text,
          price: double.parse(_priceController.text),
          quantity: int.parse(_quantityController.text),
          expiryDate: _expiryController.text,
        );
        final medicineModel = MedicineModel.fromEntity(medicine, pharmacyId);
        context.read<MedicineBloc>().add(AddMedicineEvent(medicineModel));
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Medicine',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppTheme.white : AppTheme.charcoal,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Medicine Name',
                        prefixIcon: Icon(Icons.medical_services, color: AppTheme.charcoal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppTheme.oliveGreen, width: 2),
                        ),
                        filled: true,
                        fillColor: isDarkMode ? AppTheme.cardBackgroundDark : AppTheme.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter medicine name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Icons.attach_money, color: AppTheme.charcoal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppTheme.oliveGreen, width: 2),
                        ),
                        filled: true,
                        fillColor: isDarkMode ? AppTheme.cardBackgroundDark : AppTheme.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      value!.isEmpty || double.tryParse(value) == null ? 'Enter valid price' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: Icon(Icons.inventory, color: AppTheme.charcoal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppTheme.oliveGreen, width: 2),
                        ),
                        filled: true,
                        fillColor: isDarkMode ? AppTheme.cardBackgroundDark : AppTheme.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      value!.isEmpty || int.tryParse(value) == null ? 'Enter valid quantity' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        labelText: 'Expiry Date (YYYY-MM-DD)',
                        prefixIcon: Icon(Icons.calendar_today, color: AppTheme.charcoal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppTheme.oliveGreen, width: 2),
                        ),
                        filled: true,
                        fillColor: isDarkMode ? AppTheme.cardBackgroundDark : AppTheme.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          _expiryController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                      validator: (value) => value!.isEmpty ? 'Select expiry date' : null,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.oliveGreen, Color(0xFF388E3C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add Medicine',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<MedicineBloc, MedicineState>(
                builder: (context, state) {
                  if (state is MedicineLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MedicineLoaded) {
                    return StreamBuilder<List<MedicineModel>>(
                      stream: state.medicines,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No medicines available'));
                        }
                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          final pharmacyId = authState.pharmacy.id; // Changed from .uid to .id
                          final medicines = snapshot.data!.map((model) => model.toEntity()).toList();
                          return MedicineTable(
                            medicines: medicines,
                            onEdit: (medicine) {
                              final medicineModel = MedicineModel.fromEntity(medicine, pharmacyId);
                              context.read<MedicineBloc>().add(UpdateMedicineEvent(medicineModel));
                            },
                            onDelete: (medicine) {
                              context.read<MedicineBloc>().add(DeleteMedicineEvent(medicine.id));
                            },
                          );
                        } else {
                          return const Center(child: Text('User not authenticated'));
                        }
                      },
                    );
                  } else if (state is MedicineError) {
                    return Center(
                      child: Column(
                        children: [
                          Text(state.message, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => context.read<MedicineBloc>().add(LoadMedicinesEvent()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: ElevatedButton(
                      onPressed: () => context.read<MedicineBloc>().add(LoadMedicinesEvent()),
                      child: const Text('Load Medicines'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}