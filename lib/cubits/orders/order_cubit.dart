import 'package:ahwa/models/drink.dart';
import 'package:ahwa/models/order.dart';
import 'package:ahwa/services/orders/order_service.dart';
import 'package:ahwa/services/reports/report_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderService orderService;
  final ReportService reportService;
  final List<Order> _orders = [];

  OrderCubit({required this.orderService, required this.reportService}) : super(OrderInitial());

  void addOrder(Order order) {
    _orders.add(order);
    final success = orderService.addOrder(order);
    if (success) {
      final topDrinks = reportService.generateReport(_orders);
      emit(OrderUpdated(orders: _orders, topSellingDrinks: topDrinks));
    } else {
      emit(OrderError('Failed to add order'));
    }
  }

  void completeOrder(String orderId) {
    final success = orderService.completeOrder(orderId);
    if (success) {
      final orders = orderService.getOrders();
      final topDrinks = reportService.generateReport(orders);
      emit(OrderUpdated(orders: orders, topSellingDrinks: topDrinks));
    } else {
      emit(OrderError('Order not found'));
    }
  }
}
