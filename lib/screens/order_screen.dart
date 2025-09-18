import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahwa/cubits/orders/order_cubit.dart';
import 'package:ahwa/models/order.dart';
import 'package:ahwa/enums/order_status.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Orders', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text('Start ordering from the menu', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
            final orders = state.orders;
            final topDrinks = state.topSellingDrinks;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Orders Section
                  if (orders.isNotEmpty) ...[
                    const Text(
                      'Current Orders',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return OrderCard(
                          order: order,
                          onComplete: () {
                            context.read<OrderCubit>().completeOrder(order.id);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Top Selling Drinks Section
                  if (topDrinks.isNotEmpty) ...[
                    const Text(
                      'Top Selling Drinks',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFF8B4513).withAlpha(25), const Color(0xFF8B4513).withAlpha(12)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF8B4513).withAlpha(51)),
                      ),
                      child: Column(
                        children: topDrinks.entries.take(5).map((entry) {
                          final drink = entry.key;
                          final count = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: const Color(0xFF8B4513), borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.local_cafe, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        drink.name,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
                                      ),
                                      Text('\$${drink.price.toStringAsFixed(1)}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFF8B4513), borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    '$count orders',
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onComplete;

  const OrderCard({super.key, required this.order, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(order.id.length - 6)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: order.status == OrderStatus.completed ? Colors.green : Colors.orange, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    order.status == OrderStatus.completed ? 'Completed' : 'Pending',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Order Items
            const Text(
              'Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
            ),
            const SizedBox(height: 8),
            ...order.items.map(
              (drink) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(drink.name, style: const TextStyle(fontSize: 14, color: Color(0xFF5D4037))),
                    ),
                    Text(
                      '\$${drink.price.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF8B4513)),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),

            // Order Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
                    ),
                    Text(
                      '\$${order.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8B4513)),
                    ),
                  ],
                ),
                if (order.status == OrderStatus.pending)
                  ElevatedButton.icon(
                    onPressed: onComplete,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
              ],
            ),

            // Instructions
            if (order.instructions != null && order.instructions!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Special Instructions:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
                    ),
                    const SizedBox(height: 4),
                    Text(order.instructions!, style: const TextStyle(fontSize: 12, color: Color(0xFF5D4037))),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
