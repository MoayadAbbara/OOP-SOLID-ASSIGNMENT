import 'package:ahwa/models/drink.dart';
import 'package:ahwa/models/order.dart';

abstract class ReportService {
  Map<Drink, int> generateReport(List<Order> orders);
}
