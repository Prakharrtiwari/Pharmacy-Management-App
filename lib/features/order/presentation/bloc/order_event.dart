import 'package:equatable/equatable.dart';
import 'package:pharmacy_management/features/order/data/models/order_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrderEvent extends OrderEvent {
  final OrderModel order;

  const PlaceOrderEvent(this.order);

  @override
  List<Object> get props => [order];
}

class UpdateOrderEvent extends OrderEvent {
  final OrderModel order;

  const UpdateOrderEvent(this.order);

  @override
  List<Object> get props => [order];
}

class UpdateOrderStatusEvent extends OrderEvent {
  final String id;
  final String status;

  const UpdateOrderStatusEvent(this.id, this.status);

  @override
  List<Object> get props => [id, status];
}

class LoadOrdersEvent extends OrderEvent {}