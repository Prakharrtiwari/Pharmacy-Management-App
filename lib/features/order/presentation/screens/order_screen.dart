import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management/core/theme/app_theme.dart';
import 'package:pharmacy_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pharmacy_management/features/order/data/models/order_model.dart';
import 'package:pharmacy_management/features/order/domain/entities/order.dart';
import 'package:pharmacy_management/features/order/presentation/bloc/order_bloc.dart';
import 'package:pharmacy_management/features/order/presentation/widgets/order_table.dart';
import 'package:uuid/uuid.dart';

import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _medicineIdController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _medicineIdController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _customerNameController.clear();
    _medicineIdController.clear();
    _quantityController.clear();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final pharmacyId = authState.pharmacy.id; // Changed from .uid to .id
        final order = Order(
          id: const Uuid().v4(),
          medicineId: _medicineIdController.text,
          customerName: _customerNameController.text,
          quantity: int.parse(_quantityController.text),
          status: 'Pending',
        );
        final orderModel = OrderModel.fromEntity(order, pharmacyId);
        context.read<OrderBloc>().add(PlaceOrderEvent(orderModel));
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
                'Place Order',
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
                      controller: _customerNameController,
                      decoration: InputDecoration(
                        labelText: 'Customer Name',
                        prefixIcon: Icon(Icons.person, color: AppTheme.charcoal),
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
                      validator: (value) => value!.isEmpty ? 'Enter customer name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _medicineIdController,
                      decoration: InputDecoration(
                        labelText: 'Medicine ID',
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
                      validator: (value) => value!.isEmpty ? 'Enter medicine ID' : null,
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
                          'Place Order',
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
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrderLoaded) {
                    return StreamBuilder<List<OrderModel>>(
                      stream: state.orders,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No orders available'));
                        }
                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          final pharmacyId = authState.pharmacy.id; // Changed from .uid to .id
                          final orders = snapshot.data!.map((model) => model.toEntity()).toList();
                          return OrderTable(
                            orders: orders,
                            onEdit: (order) {
                              final orderModel = OrderModel.fromEntity(order, pharmacyId);
                              context.read<OrderBloc>().add(UpdateOrderEvent(orderModel));
                            },
                            onUpdateStatus: (order, status) {
                              context.read<OrderBloc>().add(UpdateOrderStatusEvent(order.id, status));
                            },
                          );
                        } else {
                          return const Center(child: Text('User not authenticated'));
                        }
                      },
                    );
                  } else if (state is OrderError) {
                    return Center(
                      child: Column(
                        children: [
                          Text(state.message, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => context.read<OrderBloc>().add(LoadOrdersEvent()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is OrderSuccess) {
                    return const Center(child: Text('Order processed successfully'));
                  }
                  return Center(
                    child: ElevatedButton(
                      onPressed: () => context.read<OrderBloc>().add(LoadOrdersEvent()),
                      child: const Text('Load Orders'),
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