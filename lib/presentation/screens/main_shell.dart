import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xtacy_backoffice/presentation/screens/dashboard_screen.dart';
import 'package:xtacy_backoffice/presentation/screens/products_screen.dart';
import 'package:xtacy_backoffice/presentation/screens/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final _screens = const [
    DashboardScreen(),
    ProductsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => context.push('/products/add'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
