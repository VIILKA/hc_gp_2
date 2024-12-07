import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hc_gp_2/home_view/add_training_bottom_sheet.dart';
import 'package:hc_gp_2/home_view/home_page.dart';
import 'package:hc_gp_2/statistic_view/statistic_page.dart';
import 'package:hc_gp_2/styles/app_theme.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = 0;

  final homePageKey = GlobalKey<HomePageState>();

  late final List<Widget> _pages = [
    HomePage(key: homePageKey),
    const StatisticPage(),
    const HomePage(),
    const HomePage(),
  ];

  // Колбек для отображения BottomSheet
  void showAddTrainingBottomSheet(BuildContext context) async {
    bool? result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.7,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: const AddTrainingBottomSheet(),
            );
          },
        );
      },
    );

    if (result == true) {
      // Если была добавлена новая тренировка, обновляем список
      if (_currentIndex == 0 && homePageKey.currentState != null) {
        homePageKey.currentState!.refreshTrainings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          // Навигационная панель
          Positioned(
            bottom: 40.0,
            left: 40.0,
            right: 40.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2B2B2B), // Dark background color
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _NavBarItem(
                            icon: Icons.directions_run,
                            isActive: _currentIndex == 0,
                            onTap: () => _onItemTapped(0),
                          ),
                          _NavBarItem(
                            icon: Icons.bar_chart_outlined,
                            isActive: _currentIndex == 1,
                            onTap: () => _onItemTapped(1),
                          ),
                          _NavBarItem(
                            icon: Icons.settings_outlined,
                            isActive: _currentIndex == 2,
                            onTap: () => _onItemTapped(2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary, // Dark background color
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _NavBarItemS(
                              icon: Icons.add,
                              isActive: _currentIndex == 3,
                              onTap: () => showAddTrainingBottomSheet(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Кнопка добавления
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Gaimon.selection(); // Выполняем вибрацию
        onTap.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppTheme.primary : Colors.grey,
            size: 28,
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 30,
              color: AppTheme.primary, // Цвет индикатора
            ),
        ],
      ),
    );
  }
}

class _NavBarItemS extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItemS({
    required this.icon,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Gaimon.selection(); // Выполняем вибрацию
        onTap.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppTheme.primary : Colors.white,
            size: 28,
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 30,
              color: AppTheme.primary, // Цвет индикатора
            ),
        ],
      ),
    );
  }
}
