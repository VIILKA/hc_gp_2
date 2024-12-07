// models/goal.dart

import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 2)
class Goal extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String category;

  @HiveField(3)
  int targetCount;

  @HiveField(4)
  int currentCount;

  Goal({
    required this.title,
    required this.description,
    required this.category,
    required this.targetCount,
    this.currentCount = 0,
  });

  // Метод для увеличения текущего прогресса
  void incrementProgress() {
    if (currentCount < targetCount) {
      currentCount++;
      save(); // Сохраняем изменения в Hive
    }
  }

  // Метод для уменьшения текущего прогресса (при удалении тренировки)
  void decrementProgress() {
    if (currentCount > 0) {
      currentCount--;
      save();
    }
  }
}
