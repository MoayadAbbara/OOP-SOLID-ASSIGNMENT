import 'package:flutter/material.dart';
import 'package:ahwa/screens/orders_screen.dart';
import 'package:ahwa/screens/reports_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const OrdersScreen(), const ReportsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF8B4513), // Coffee brown
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), activeIcon: Icon(Icons.receipt_long, size: 28), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), activeIcon: Icon(Icons.analytics, size: 28), label: 'Reports'),
        ],
      ),
    );
  }
}
