// widgets/goal_card.dart

import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hc_gp_2/models/goal.dart';
import 'package:hc_gp_2/styles/app_theme.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onDelete;
  final VoidCallback onTap; // Новый параметр для обработки нажатия

  const GoalCard({
    Key? key,
    required this.goal,
    required this.onDelete,
    required this.onTap, // Обязательный параметр
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = goal.currentCount / goal.targetCount;

    return GestureDetector(
      onTap: () {
        onTap.call();
        Gaimon.selection();
      }, // Обработка нажатия на карточку
      child: Container(
        width:
            250, // Фиксированная ширина для корректного отображения в горизонтальном списке
        height: 260, // Фиксированная высота для всех карточек
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface, // Темный фон
          borderRadius: BorderRadius.circular(12), // Закругленные углы
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхняя строка: заголовок и кнопка удаления
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flag, color: Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      "Goal",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    onDelete.call();
                    Gaimon.selection();
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Заголовок цели
            Text(
              goal.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1, // Ограничение количества строк
              overflow: TextOverflow
                  .ellipsis, // Добавление многоточия при переполнении
            ),
            const SizedBox(height: 16),
            // Прогресс
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Распределение пространства
              children: [
                // Левая сторона: текущее и целевое количество
                Row(
                  children: [
                    Text(
                      "${goal.currentCount}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "из ${goal.targetCount}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Правая сторона: иконка и название категории
                Row(
                  children: [
                    Icon(
                      _getIconForCategory(goal.category),
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      goal.category,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Индикатор прогресса
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[800],
              color: const Color(0xFF5B5CFF),
              minHeight: 4,
            ),
            const SizedBox(height: 16),
            // Описание цели
            Expanded(
              child: Text(
                goal.description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 2, // Ограничение количества строк
                overflow: TextOverflow
                    .ellipsis, // Добавление многоточия при переполнении
              ),
            ),
          ],
        ),
      ),
    );
  }

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
