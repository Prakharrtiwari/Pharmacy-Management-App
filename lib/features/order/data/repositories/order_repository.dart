import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy_management/features/order/data/models/order_model.dart';

class OrderRepository {
  final CollectionReference _ordersCollection =
  FirebaseFirestore.instance.collection('orders');

  Future<void> placeOrder(OrderModel order, String pharmacyId) async {
    try {
      await _ordersCollection.doc(order.id).set({
        ...order.toJson(),
        'pharmacyId': pharmacyId,
      });
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  Future<void> updateOrder(OrderModel order, String pharmacyId) async {
    try {
      await _ordersCollection.doc(order.id).update({
        ...order.toJson(),
        'pharmacyId': pharmacyId,
      });
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  Future<void> updateOrderStatus(String id, String status, String pharmacyId) async {
    try {
      await _ordersCollection.doc(id).update({
        'status': status,
        'pharmacyId': pharmacyId,
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Stream<List<OrderModel>> getOrders(String pharmacyId) {
    try {
      return _ordersCollection
          .where('pharmacyId', isEqualTo: pharmacyId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return OrderModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}