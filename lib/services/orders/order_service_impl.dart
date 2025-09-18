import 'package:ahwa/enums/order_status.dart';
import 'package:ahwa/models/order.dart';
import 'package:ahwa/services/orders/order_service.dart';

//this class will mock database operations for orders
class OrderServiceImpl implements OrderService {
  final List<Order> _orders = [];

  @override
  bool addOrder(Order order) {
    try {
      _orders.add(order);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  List<Order> getOrders() {
    return List.unmodifiable(_orders);
  }

  @override
  bool removeOrder(String orderId) {
    if (_orders.any((order) => order.id == orderId)) {
      _orders.removeWhere((order) => order.id == orderId);
      return true;
    }
    return false;
  }

  @override
  bool completeOrder(String orderId) {
    for (var order in _orders) {
      if (order.id == orderId) {
        order.status = OrderStatus.completed;
        return true;
      }
    }
    return false;
  }
}
