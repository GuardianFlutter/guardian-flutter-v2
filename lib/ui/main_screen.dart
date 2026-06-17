import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'home/home_screen.dart';
import 'map/map_screen.dart';
import 'report/report_screen.dart';
import 'sos/sos_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MapScreen(),
    ReportScreen(),
    SosScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.borderColor, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),     activeIcon: Icon(Icons.home),          label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined),      activeIcon: Icon(Icons.map),           label: 'Mapa'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline),activeIcon: Icon(Icons.add_circle),    label: 'Reportar'),
            BottomNavigationBarItem(icon: Icon(Icons.warning_amber_outlined), activeIcon: Icon(Icons.warning_amber), label: 'SOS'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline),    activeIcon: Icon(Icons.person),        label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
