import 'package:flutter/material.dart';
import '/home/screens/home_screen.dart';
import '/data_entry/screens/add_entry_screen.dart';
import '/home/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AddEntryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != 1) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0),
              const SizedBox(width: 50),
              _buildNavItem(Icons.person, 2),
            ],
          ),
        ),
      ),
      floatingActionButton: isKeyboardOpen
          ? null
          : FloatingActionButton(
        onPressed: () => setState(() => _selectedIndex = 1),
        shape: const CircleBorder(),
        elevation: 6,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFEEAECA), Color(0xFF94BBE9)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;
    return IconButton(
      onPressed: () => _onItemTapped(index),
      icon: Container(
        decoration: isSelected
            ? const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFEEAECA), Color(0xFF94BBE9)],
          ),
        )
            : null,
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[700],
          size: 20,
        ),
      ),
    );
  }
}
