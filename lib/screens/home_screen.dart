import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahwa/screens/order_screen.dart';
import 'package:ahwa/models/drink.dart';
import 'package:ahwa/models/turkish_coffe.dart';
import 'package:ahwa/models/order.dart';
import 'package:ahwa/cubits/orders/order_cubit.dart';
import 'package:ahwa/data/drink_data_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Drink> cart = [];
  late List<Drink> featuredDrinks;

  @override
  void initState() {
    super.initState();
    featuredDrinks = DrinkDataProvider.getFeaturedDrinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Ahwa', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        elevation: 0,
        actions: [
          IconButton(
            icon: Badge(label: Text('${cart.length}'), child: const Icon(Icons.shopping_bag_outlined)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF8B4513), const Color(0xFF8B4513).withAlpha((0.8 * 255).toInt())],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to Ahwa',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text('Discover the finest coffee and tea experience', style: TextStyle(fontSize: 16, color: Colors.white.withAlpha((0.9 * 255).toInt()))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Categories Section
              const Text(
                'Categories',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CategoryCard(title: 'Turkish Coffee', icon: Icons.coffee, color: const Color(0xFF8B4513), onTap: () => _showDrinksByCategory('Turkish Coffee')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CategoryCard(title: 'Tea', icon: Icons.local_cafe, color: const Color(0xFF4CAF50), onTap: () => _showDrinksByCategory('Tea')),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Featured Drinks Section
              const Text(
                'Featured Drinks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: featuredDrinks.length,
                itemBuilder: (context, index) {
                  final drink = featuredDrinks[index];
                  return DrinkCard(drink: drink, onAddToCart: () => _addToCart(drink));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(Drink drink) {
    setState(() {
      cart.add(drink);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${drink.name} added to cart'),
        backgroundColor: const Color(0xFF8B4513),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Add order to cubit if cart has items
    if (cart.isNotEmpty) {
      final order = Order(id: DateTime.now().millisecondsSinceEpoch.toString(), items: List.from(cart), totalPrice: cart.fold(0.0, (sum, drink) => sum + drink.price));
      context.read<OrderCubit>().addOrder(order);
    }
  }

  void _showDrinksByCategory(String category) {
    List<Drink> categoryDrinks;
    if (category == 'Turkish Coffee') {
      categoryDrinks = DrinkDataProvider.getTurkishCoffees();
    } else {
      categoryDrinks = DrinkDataProvider.getTeas();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  category,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: categoryDrinks.length,
                  itemBuilder: (context, index) {
                    final drink = categoryDrinks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          drink.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(drink.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: SizedBox(
                          width: 60,
                          child: Text(
                            '\$${drink.price.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF8B4513)),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        onTap: () => _addToCart(drink),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha((0.3 * 255).toInt())),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrinkCard extends StatelessWidget {
  final Drink drink;
  final VoidCallback onAddToCart;

  const DrinkCard({super.key, required this.drink, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drink Image Placeholder
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513).withAlpha((0.1 * 255).toInt()),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Icon(drink is TurkishCoffee ? Icons.coffee : Icons.local_cafe, size: 40, color: const Color(0xFF8B4513)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drink.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        drink.description,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '\$${drink.price.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF8B4513)),
                        ),
                      ),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: const Color(0xFF8B4513), borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.add, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
