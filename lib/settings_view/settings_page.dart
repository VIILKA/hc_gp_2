import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hc_gp_2/styles/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showAppData({
    required BuildContext context,
    required String link,
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoPopupSurface(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: Navigator.of(context).pop,
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 20,
                      color: CupertinoColors.darkBackgroundGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),

              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Подзаголовок
              Text(
                'Application settings',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),

              SizedBox(height: 16),

              SizedBox(height: 40),

              Center(
                child: Column(
                  children: [
                    Text(
                      'PeakProgress Win',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),

              SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E), // Фон карточки
          borderRadius: BorderRadius.circular(12), // Скругленные углы
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Карточка обратной связи
  Widget _buildFeedbackCard(VoidCallback callback) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E), // Фон карточки
        borderRadius: BorderRadius.circular(12), // Скругленные углы
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.feedback,
            color: AppTheme.primary,
            size: 24,
          ),
          const Spacer(),
          const Text(
            'Feedback',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Send feedback, suggestions, or bug reports.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: AppTheme.primary, // Цвет кнопки
              borderRadius: BorderRadius.circular(8),
              onPressed: () {
                Gaimon.selection();
                callback.call();
              },
              child: const Text(
                'Send',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
