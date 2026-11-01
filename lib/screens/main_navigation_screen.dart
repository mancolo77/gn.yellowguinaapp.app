import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tabs/calendrier_tab.dart';
import 'tabs/favoris_tab.dart';
import 'tabs/mon_profil_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  final List<Widget> _tabs = const [
    CalendrierTab(),
    FavorisTab(),
    MonProfilTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: Container(
        color: AppTheme.darkNav,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: AppTheme.darkNav,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Calendrier'),
            BottomNavigationBarItem(icon: Icon(Icons.star_rounded), label: 'Favoris'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Mon profil'),
          ],
        ),
      ),
    );
  }
}
