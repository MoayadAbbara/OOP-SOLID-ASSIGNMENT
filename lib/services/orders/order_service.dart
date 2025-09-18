import 'package:ahwa/models/order.dart';

abstract class OrderService {
  bool addOrder(Order order);
  List<Order> getOrders();
  bool removeOrder(String orderId);
  bool completeOrder(String orderId);
}
