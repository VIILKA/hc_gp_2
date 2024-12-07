// statistic_view/statistic_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hive/hive.dart';
import 'package:hc_gp_2/models/goal.dart';
import 'package:hc_gp_2/models/training.dart';
import 'package:hc_gp_2/statistic_view/add_goal.dart';
import 'package:hc_gp_2/styles/app_theme.dart';
import 'package:hc_gp_2/widgets/goal_card.dart';
import 'package:hc_gp_2/widgets/weekly_statistic.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  List<Map<String, dynamic>> activities = [
    {'icon': Icons.directions_run, 'label': 'Running', 'value': 0},
    {'icon': Icons.pedal_bike, 'label': 'Cycling', 'value': 0},
    {'icon': Icons.pool, 'label': 'Swimming', 'value': 0},
    {'icon': Icons.self_improvement, 'label': 'Yoga', 'value': 0},
    {'icon': Icons.directions_walk, 'label': 'Squats', 'value': 0},
    {'icon': Icons.accessibility_new, 'label': 'Lunges', 'value': 0},
    {'icon': Icons.fitness_center, 'label': 'Deadlifts', 'value': 0},
  ];

  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();
    _loadActivityData();
    _loadGoals();
  }

  Future<void> _loadActivityData() async {
    var box = await Hive.openBox<Training>('trainings');
    List<Training> trainings = box.values.toList();

    // Reset counts
    activities = activities.map((activity) {
      activity['value'] = 0;
      return activity;
    }).toList();

    // Count occurrences
    for (var training in trainings) {
      for (var activity in activities) {
        if (training.category == activity['label']) {
          activity['value'] += 1;
          break;
        }
      }
    }

    setState(() {});
  }

  Future<void> _loadGoals() async {
    var box = await Hive.openBox<Goal>('goals');
    setState(() {
      goals = box.values.toList();
    });
  }

  void _addGoal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Позволяет использовать полный размер экрана при необходимости
      backgroundColor: Colors
          .transparent, // Убираем стандартный фон для настройки кастомного
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.background, // Темный фон
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: AddGoal(
            onSave: () {
              _loadGoals();
            },
          ),
        );
      },
    );
  }

  void _editGoal(Goal goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Позволяет использовать полный размер экрана при необходимости
      backgroundColor: Colors
          .transparent, // Убираем стандартный фон для настройки кастомного
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.background, // Темный фон
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: AddGoal(
            existingGoal: goal, // Передаём существующую цель для редактирования
            onSave: () {
              _loadGoals();
            },
          ),
        );
      },
    );
  }

  void _deleteGoal(int index) async {
    await goals[index].delete();
    _loadGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () async {
            await _loadActivityData();
            await _loadGoals();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style: AppTheme.displayMedium
                        .copyWith(color: AppTheme.secondary),
                  ),
                  const SizedBox(height: 16),
                  const WeeklyStatisticsWidget(),
                  const SizedBox(height: 16),
                  Text(
                    'Category statistics',
                    style:
                        AppTheme.bodyMedium.copyWith(color: AppTheme.onPrimary),
                  ),
                  const SizedBox(height: 8),
                  // Category statistics
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: activities.map((activity) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: 110,
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  activity['value'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      activity['icon'],
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        activity['label'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Goal progress',
                    style:
                        AppTheme.bodyMedium.copyWith(color: AppTheme.onPrimary),
                  ),
                  const SizedBox(height: 8),
                  // Goals
                  goals.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: goals.map((goal) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GoalCard(
                                  goal: goal,
                                  onDelete: () {
                                    _deleteGoal(goals.indexOf(goal));
                                  },
                                  onTap: () {
                                    _editGoal(goal);
                                    Gaimon
                                        .selection(); // Обработка нажатия на цель
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : Center(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/54d5782f2b166b33c4c28abcdcd2ea77.png'),
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Затемняющий слой
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(
                                        0.3), // Полупрозрачный черный цвет
                                    borderRadius: BorderRadius.circular(
                                        12), // Совпадает с родительским контейнером
                                  ),
                                ),
                                // Текст поверх затемняющего слоя
                                Center(
                                  child: const Text(
                                    'No goals added yet.',
                                    style: TextStyle(
                                      color: Color.fromARGB(199, 255, 255,
                                          255), // Белый цвет текста для лучшей видимости
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                  const SizedBox(height: 16),
                  Center(
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14), // Отступы внутри кнопки
                      color: AppTheme.onSurface, // Цвет кнопки
                      borderRadius:
                          BorderRadius.circular(24), // Скругленные углы
                      onPressed: () {
                        _addGoal.call();
                        Gaimon.selection();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Размер под содержимое
                        children: [
                          Icon(
                            Icons.radio_button_checked, // Иконка
                            color: AppTheme.primary, // Цвет иконки
                            size: 20,
                          ),
                          const SizedBox(
                              width: 8), // Расстояние между иконкой и текстом
                          const Text(
                            'Add goal',
                            style: TextStyle(
                              color: Colors.white, // Цвет текста
                              fontSize: 16, // Размер текста
                              fontWeight: FontWeight.w500, // Полужирный шрифт
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        )));
  }
}
