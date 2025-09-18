import 'package:ahwa/enums/order_status.dart';
import 'package:ahwa/models/drink.dart';

class Order {
  final String id;
  final List<Drink> items;
  final double totalPrice;
  final String? instructions;
  OrderStatus status;

  Order({required this.id, required this.items, required this.totalPrice, this.instructions}) : status = OrderStatus.pending;
}
