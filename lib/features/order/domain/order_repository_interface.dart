import 'package:pharmacy_management/features/order/data/models/order_model.dart';

abstract class OrderRepositoryInterface {
  Future<void> placeOrder(OrderModel order);
  Future<void> updateOrderStatus(String id, String status);
  Stream<List<OrderModel>> getOrders();
}