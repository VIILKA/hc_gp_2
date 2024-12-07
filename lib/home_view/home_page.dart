// home_view/home_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Используйте hive_flutter
import 'package:hc_gp_2/home_view/add_feeling_bottom_sheet.dart';
import 'package:hc_gp_2/home_view/open_training_page.dart';
import 'package:hc_gp_2/models/activity.dart';
import 'package:hc_gp_2/models/feeling.dart';
import 'package:hc_gp_2/models/training.dart';
import 'package:hc_gp_2/styles/app_theme.dart';
import 'package:hc_gp_2/widgets/daily_feeling_widget.dart';
import 'package:hc_gp_2/widgets/training_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<ActivityCardData> activities = [
    ActivityCardData(icon: Icons.directions_run, label: "Running"),
    ActivityCardData(icon: Icons.pedal_bike, label: "Cycling"),
    ActivityCardData(icon: Icons.pool, label: "Swimming"),
    ActivityCardData(icon: Icons.self_improvement, label: "Yoga"),
    ActivityCardData(icon: Icons.directions_walk, label: "Squats"),
    ActivityCardData(icon: Icons.accessibility_new, label: "Lunges"),
    ActivityCardData(icon: Icons.fitness_center, label: "Deadlifts"),
  ];

  List<Training> todaysTrainings = [];
  int totalDuration = 0;
  int totalCalories = 0;
  String? selectedActivityFilter;

  @override
  void initState() {
    super.initState();
    loadTrainings();
  }

  void loadTrainings({String? filter}) async {
    var box = Hive.box<Training>('trainings');
    List<Training> allTrainings = box.values.toList();

    // Фильтруем тренировки по сегодняшней дате и выбранной категории
    DateTime today = DateTime.now();
    todaysTrainings = allTrainings.where((training) {
      bool isToday = training.date.year == today.year &&
          training.date.month == today.month &&
          training.date.day == today.day;
      if (filter != null) {
        return isToday && training.category == filter;
      } else {
        return isToday;
      }
    }).toList();

    // Вычисляем общую длительность и калории
    totalDuration =
        todaysTrainings.fold(0, (sum, item) => sum + item.durationInMinutes);
    totalCalories =
        todaysTrainings.fold(0, (sum, item) => sum + item.caloriesBurned);

    setState(() {});
  }

  void refreshTrainings() {
    loadTrainings(filter: selectedActivityFilter);
  }

  // Модифицированный метод для открытия BottomSheet с возможностью передачи существующего настроения
  void _openAddFeelingSheet(Feeling? existingFeeling) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Позволяет листу адаптироваться под содержимое
      backgroundColor: Colors.transparent, // Для настройки фона
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Учитывает высоту клавиатуры
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.background, // Темный фон
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            child: AddFeelingSheet(
              existingFeeling:
                  existingFeeling, // Передача существующего настроения
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Виджет ежедневного настроения с использованием ValueListenableBuilder
              ValueListenableBuilder<Box<Feeling>>(
                valueListenable: Hive.box<Feeling>('feelings').listenable(),
                builder: (context, box, _) {
                  DateTime today = DateTime.now();
                  List<Feeling> todayFeelings = box.values.where((feeling) {
                    return feeling.date.year == today.year &&
                        feeling.date.month == today.month &&
                        feeling.date.day == today.day;
                  }).toList();

                  Feeling? todayFeeling =
                      todayFeelings.isNotEmpty ? todayFeelings.first : null;

                  return DailyFeelingWidget(
                    feeling: todayFeeling,
                    onAddFeeling: () => _openAddFeelingSheet(todayFeeling),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Заголовок статистики активности
              Text(
                "Today's Activity Stats",
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.onPrimary),
              ),
              const SizedBox(height: 16),
              // Карточки статистики
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _StatCard(
                      value:
                          "${totalDuration ~/ 60} h ${totalDuration % 60} min",
                      label: "Duration",
                      icon: Icons.timer_outlined,
                    ),
                  ),
                  const SizedBox(width: 16), // Отступ между карточками
                  Expanded(
                    child: _StatCard(
                      value: "$totalCalories cal",
                      label: "Calories Burned",
                      icon: Icons.local_fire_department_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Заголовок раздела тренировок
              Text(
                "Training",
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.onPrimary),
              ),
              const SizedBox(height: 8),
              // Фильтрация по категориям тренировок
              SizedBox(
                height: 90, // Высота виджета
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ActivityCard(
                        icon: activity.icon,
                        label: activity.label,
                        isSelected: selectedActivityFilter == activity.label,
                        onTap: () {
                          setState(() {
                            if (selectedActivityFilter == activity.label) {
                              selectedActivityFilter = null;
                            } else {
                              selectedActivityFilter = activity.label;
                            }
                            loadTrainings(filter: selectedActivityFilter);
                          });
                          Gaimon.selection();
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Список тренировок или сообщение об отсутствии
              todaysTrainings.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: todaysTrainings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16), // Отступ между карточками
                      itemBuilder: (context, index) {
                        final training = todaysTrainings[index];
                        return TrainingCard(
                          training: training,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OpenTrainingPage(training: training),
                              ),
                            ).then((value) {
                              if (value == true) {
                                refreshTrainings();
                              }
                            });
                            Gaimon.selection();
                          },
                        );
                      },
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "You haven't added any trainings yet",
                              style: AppTheme.bodyLarge
                                  .copyWith(color: AppTheme.onPrimary),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(
                  height:
                      200), // Отступ внизу для избежания наложения на другие элементы
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Ширина управляется родительским Expanded
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface, // Темный фон карточки
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Значение
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value.split(' ')[0], // Часть значения до пробела
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      " ${value.split(' ').skip(1).join(' ')}", // Остальная часть
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Метка
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.onPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.onPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
        Gaimon.selection();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.black.withOpacity(0.2)
                  : Colors.transparent,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.onPrimary,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
