import 'package:flutter/material.dart';
import 'package:slice_of_heaven/features/cart/presentation/pages/cart_screen.dart';
import 'package:slice_of_heaven/features/home/presentation/pages/home_screen.dart';
import 'package:slice_of_heaven/features/order/presentation/pages/order_history_page.dart';
import 'package:slice_of_heaven/features/profile/presentation/pages/profile_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const CartScreen(),
    const OrderHistoryPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Slice of Heaven"),
        
      ),

      body: screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 108, 38, 2),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}