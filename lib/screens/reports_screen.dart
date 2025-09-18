import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahwa/cubits/orders/order_cubit.dart';
import 'package:ahwa/models/drink.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ahwa Manager - Reports', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No data yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text('Complete some orders to see reports', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          if (state is OrderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is OrderUpdated) {
            if (state.topSellingDrinks.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No sales data yet',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text('Start taking orders to see analytics', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              );
            }

            final totalOrders = state.orders.length;
            final completedOrders = state.orders.where((o) => o.status.toString() == 'OrderStatus.completed').length;
            final totalRevenue = state.orders.fold<double>(0.0, (sum, order) => sum + order.totalPrice);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary cards
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(title: 'Total Orders', value: totalOrders.toString(), icon: Icons.receipt_long, color: const Color(0xFF8B4513)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(title: 'Completed', value: completedOrders.toString(), icon: Icons.check_circle, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SummaryCard(title: 'Total Revenue', value: '\$${totalRevenue.toStringAsFixed(2)}', icon: Icons.attach_money, color: const Color(0xFF4CAF50), isWide: true),
                  const SizedBox(height: 24),

                  // Top selling drinks section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [const Color(0xFF8B4513), const Color(0xFF8B4513).withAlpha(204)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.trending_up, color: Colors.white, size: 24),
                            const SizedBox(width: 8),
                            const Text(
                              'Top Selling Drinks',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Ya rais, here are your most popular items:', style: TextStyle(color: Colors.white.withAlpha(230), fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Top drinks list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.topSellingDrinks.length,
                    itemBuilder: (context, index) {
                      final entry = state.topSellingDrinks.entries.elementAt(index);
                      final drink = entry.key;
                      final count = entry.value;

                      return _DrinkReportCard(drink: drink, count: count, rank: index + 1, isTopRank: index < 3);
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isWide;

  const _SummaryCard({required this.title, required this.value, required this.icon, required this.color, this.isWide = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: isWide ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isWide ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: isWide ? 32 : 28, fontWeight: FontWeight.bold, color: color),
            textAlign: isWide ? TextAlign.center : TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class _DrinkReportCard extends StatelessWidget {
  final Drink drink;
  final int count;
  final int rank;
  final bool isTopRank;

  const _DrinkReportCard({required this.drink, required this.count, required this.rank, required this.isTopRank});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isTopRank ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isTopRank ? BorderSide(color: const Color(0xFF8B4513).withAlpha(76), width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: isTopRank ? const Color(0xFF8B4513) : Colors.grey[400], shape: BoxShape.circle),
              child: Center(
                child: Text(
                  '$rank',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Drink info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drink.name,
                    style: TextStyle(fontSize: 16, fontWeight: isTopRank ? FontWeight.bold : FontWeight.w600, color: const Color(0xFF3E2723)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    drink.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Count and revenue
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: isTopRank ? const Color(0xFF8B4513).withAlpha(25) : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    '$count sold',
                    style: TextStyle(color: isTopRank ? const Color(0xFF8B4513) : Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${(drink.price * count).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
