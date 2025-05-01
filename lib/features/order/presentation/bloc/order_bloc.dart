import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pharmacy_management/features/order/data/models/order_model.dart';
import 'package:pharmacy_management/features/order/data/repositories/order_repository.dart';

import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final String pharmacyId;

  OrderBloc({required this.pharmacyId, OrderRepository? orderRepository})
      : _orderRepository = orderRepository ?? OrderRepository(),
        super(OrderInitial()) {
    on<PlaceOrderEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        await _orderRepository.placeOrder(event.order, pharmacyId);
        emit(OrderSuccess());
        add(LoadOrdersEvent());
      } catch (e) {
        emit(OrderError('Failed to place order: ${e.toString()}'));
      }
    });

    on<UpdateOrderEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        await _orderRepository.updateOrder(event.order, pharmacyId);
        emit(OrderSuccess());
        add(LoadOrdersEvent());
      } catch (e) {
        emit(OrderError('Failed to update order: ${e.toString()}'));
      }
    });

    on<UpdateOrderStatusEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        await _orderRepository.updateOrderStatus(event.id, event.status, pharmacyId);
        emit(OrderSuccess());
        add(LoadOrdersEvent());
      } catch (e) {
        emit(OrderError('Failed to update status: ${e.toString()}'));
      }
    });

    on<LoadOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final stream = _orderRepository.getOrders(pharmacyId);
        emit(OrderLoaded(stream));
      } catch (e) {
        emit(OrderError('Failed to load orders: ${e.toString()}'));
      }
    });
  }
}