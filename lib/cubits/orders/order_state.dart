part of 'order_cubit.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderUpdated extends OrderState {
  final List<Order> orders;
  final Map<Drink, int> topSellingDrinks;

  OrderUpdated({required this.orders, required this.topSellingDrinks});
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}
