import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl/intl.dart';
import 'package:hc_gp_2/models/training.dart';
import 'package:hc_gp_2/styles/app_theme.dart';

class TrainingCard extends StatelessWidget {
  final Training training;
  final VoidCallback onTap;

  const TrainingCard({super.key, required this.training, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd, yyyy').format(training.date);

    int hours = training.durationInMinutes ~/ 60;
    int minutes = training.durationInMinutes % 60;

    return GestureDetector(
      onTap: () {
        onTap.call();
        Gaimon.selection();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхняя часть: категория с иконкой
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconForCategory(training.category),
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  training.category,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Описание тренировки
                  Text(
                    training.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Дата тренировки
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Разделительная линия
            Divider(color: Colors.grey[700], thickness: 1),
            const SizedBox(height: 16),
            // Статистика (длительность и калории)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatRow(
                  icon: Icons.timer,
                  label: "Duration",
                  value: "$hours h $minutes min",
                ),
                const SizedBox(
                  width: 30,
                ),
                _buildStatRow(
                  icon: Icons.local_fire_department,
                  label: "Calories burned",
                  value: "${training.caloriesBurned} cal",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey, size: 18),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value.split(' ')[0], // Часы или калории
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              value.split(' ')[1], // "h", "min" или "cal"
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Метод для получения иконки по категории
  IconData _getIconForCategory(String category) {
    switch (category) {
      case "Running":
        return Icons.directions_run;
      case "Cycling":
        return Icons.pedal_bike;
      case "Swimming":
        return Icons.pool;
      case "Yoga":
        return Icons.self_improvement;
      case "Squats":
        return Icons.directions_walk;
      case "Lunges":
        return Icons.accessibility_new;
      case "Deadlifts":
        return Icons.fitness_center;
      default:
        return Icons.help;
    }
  }
}
