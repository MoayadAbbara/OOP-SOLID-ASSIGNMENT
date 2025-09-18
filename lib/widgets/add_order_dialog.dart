import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahwa/models/order.dart';
import 'package:ahwa/models/drink.dart';
import 'package:ahwa/cubits/orders/order_cubit.dart';
import 'package:ahwa/data/drink_data_provider.dart';

class AddOrderDialog extends StatefulWidget {
  const AddOrderDialog({super.key});

  @override
  State<AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<AddOrderDialog> {
  final _customerNameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final List<Drink> _selectedDrinks = [];
  final List<Drink> _availableDrinks = DrinkDataProvider.getAllDrinks();

  @override
  void dispose() {
    _customerNameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    return _selectedDrinks.fold(0.0, (sum, drink) => sum + drink.price);
  }

  void _addDrink(Drink drink) {
    setState(() {
      _selectedDrinks.add(drink);
    });
  }

  void _removeDrink(int index) {
    setState(() {
      _selectedDrinks.removeAt(index);
    });
  }

  void _submitOrder() {
    if (_customerNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter customer name'), backgroundColor: Colors.red));
      return;
    }

    if (_selectedDrinks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one drink'), backgroundColor: Colors.red));
      return;
    }

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(_selectedDrinks),
      totalPrice: _totalPrice,
      instructions: _instructionsController.text.trim().isEmpty ? null : _instructionsController.text.trim(),
    );

    context.read<OrderCubit>().addOrder(order);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Order added for ${_customerNameController.text}'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF8B4513),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_circle, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'New Order',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer name
                    const Text(
                      'Customer Name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _customerNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter customer name...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF8B4513)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Drinks selection
                    const Text(
                      'Select Drinks',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: _availableDrinks.length,
                        itemBuilder: (context, index) {
                          final drink = _availableDrinks[index];
                          return ListTile(
                            title: Text(drink.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            subtitle: Text(
                              '\$${drink.price.toStringAsFixed(1)}',
                              style: const TextStyle(color: Color(0xFF8B4513), fontWeight: FontWeight.w600),
                            ),
                            trailing: IconButton(
                              onPressed: () => _addDrink(drink),
                              icon: const Icon(Icons.add_circle, color: Color(0xFF8B4513)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selected drinks
                    if (_selectedDrinks.isNotEmpty) ...[
                      const Text(
                        'Selected Drinks',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 120),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _selectedDrinks.length,
                          itemBuilder: (context, index) {
                            final drink = _selectedDrinks[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                title: Text(drink.name, style: const TextStyle(fontSize: 14)),
                                subtitle: Text(
                                  '\$${drink.price.toStringAsFixed(1)}',
                                  style: const TextStyle(color: Color(0xFF8B4513), fontWeight: FontWeight.w600),
                                ),
                                trailing: IconButton(
                                  onPressed: () => _removeDrink(index),
                                  icon: const Icon(Icons.remove_circle, color: Colors.red, size: 20),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Special instructions
                    const Text(
                      'Special Instructions (Optional)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _instructionsController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'e.g., extra mint, ya rais...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF8B4513)),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer with total and buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  if (_selectedDrinks.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '\$${_totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8B4513)),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B4513),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Add Order'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
