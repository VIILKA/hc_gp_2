// onboarding_view/onboarding_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hc_gp_2/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:hc_gp_2/styles/app_theme.dart';
import 'package:hive/hive.dart'; // Добавьте импорт Hive

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to the Health and Activity Diary',
      'subtitle': 'Easily track your physical activity and health.',
      'imagePath': 'assets/images/7a47c88bd934d57390bcca897d39c351.png',
    },
    {
      'title': 'Record your health and activity',
      'subtitle':
          'Conveniently record your workouts, well-being, and physical performance.',
      'imagePath': 'assets/images/e0272a6eae0e8e900f561a0e48d2ddc1.png',
    },
    {
      'title': 'Keep track of your progress',
      'subtitle': 'Record daily results and note improvements.',
      'imagePath': 'assets/images/173853dc074e02a14a80ef73f7b6b27c.png',
    },
    {
      'title': 'Ready to get started?',
      'subtitle': 'Add your first health or activity record and track changes!',
      'imagePath': 'assets/images/ea3b707557e369045fc12b9b0fd433a9.png',
    },
  ];

  void _nextPage() async {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Установка флага завершения онбординга
      var settingsBox = Hive.box('settings');
      await settingsBox.put('isOnboardingCompleted', true);

      // Переход к следующему экрану
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomNavigationBar(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // Тёмный фон
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final page = _pages[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              // Фоновое изображение
              Image.asset(
                page['imagePath']!,
                fit: BoxFit.cover,
              ),
              // Контент поверх изображения
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 600,
                    ), // Заголовок
                    Text(
                      page['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Подзаголовок
                    Text(
                      page['subtitle']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255),
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),
                    // Кнопка
                    CupertinoButton(
                      color: _currentIndex == _pages.length - 1
                          ? const Color(0xFF5B5CFF)
                          : AppTheme.primary,
                      borderRadius: BorderRadius.circular(24),
                      onPressed: () {
                        _nextPage();

                        Gaimon.selection();
                      },
                      child: Text(
                        _currentIndex == _pages.length - 1
                            ? 'Get started'
                            : 'Next',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
