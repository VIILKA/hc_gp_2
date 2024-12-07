import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hc_gp_2/models/training.dart';
import 'package:hc_gp_2/styles/app_theme.dart';

class WeeklyStatisticsWidget extends StatefulWidget {
  const WeeklyStatisticsWidget({super.key});

  @override
  State<WeeklyStatisticsWidget> createState() => _WeeklyStatisticsWidgetState();
}

class _WeeklyStatisticsWidgetState extends State<WeeklyStatisticsWidget> {
  int _currentWeekIndex = 0;
  List<Map<String, dynamic>> _weeklyData = [];
  List<DateTime> _weekStartDates = [];

  @override
  void initState() {
    super.initState();
    _loadWeeklyData();
  }

  Future<void> _loadWeeklyData() async {
    var box = await Hive.openBox<Training>('trainings');
    List<Training> trainings = box.values.toList();

    // Group trainings by week starting from the beginning of the month
    Map<int, List<Training>> weekGroups = {};

    for (var training in trainings) {
      DateTime date = training.date;
      int weekOfMonth = ((date.day - 1) / 7).floor(); // 0-based index
      int key = date.month * 100 + weekOfMonth; // Unique key for each week
      if (!weekGroups.containsKey(key)) {
        weekGroups[key] = [];
      }
      weekGroups[key]!.add(training);
    }

    // Sort the weeks
    List<int> sortedKeys = weekGroups.keys.toList()..sort();

    // Prepare data for the widget
    _weeklyData = [];
    _weekStartDates = [];

    for (var key in sortedKeys) {
      List<Training> weekTrainings = weekGroups[key]!;

      // Create a list of 7 days starting from the first day of the week
      DateTime weekStartDate = DateTime(
        weekTrainings.first.date.year,
        weekTrainings.first.date.month,
        (weekTrainings.first.date.day - (weekTrainings.first.date.weekday - 1)),
      );

      List<int> dailyValues = List.generate(7, (index) => 0);
      List<String> days = List.generate(7, (index) {
        DateTime day = weekStartDate.add(Duration(days: index));
        return DateFormat('d').format(day);
      });

      // Sum up the durations or counts for each day
      for (var training in weekTrainings) {
        int dayIndex = training.date.weekday - 1; // 0-based index
        // You can sum durations or counts here
        dailyValues[dayIndex] += 1; // Counting the number of trainings
        // Alternatively, sum durations:
        // dailyValues[dayIndex] += training.durationInMinutes;
      }

      _weeklyData.add({
        'values': dailyValues,
        'days': days,
      });
      _weekStartDates.add(weekStartDate);
    }

    setState(() {});
  }

  void _changeWeek(int direction) {
    setState(() {
      _currentWeekIndex = (_currentWeekIndex + direction) % _weeklyData.length;
      if (_currentWeekIndex < 0) {
        _currentWeekIndex = _weeklyData.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_weeklyData.isEmpty) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final data = _weeklyData[_currentWeekIndex]['values'] as List<int>;
    final days = _weeklyData[_currentWeekIndex]['days'] as List<String>;
    DateTime weekStartDate = _weekStartDates[_currentWeekIndex];
    String monthName = DateFormat('MMMM').format(weekStartDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface, // Dark background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Training statistics",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment:
                CrossAxisAlignment.end, // Align bars at the bottom
            children: List.generate(data.length, (index) {
              return _BarChartItem(
                value: data[index],
                day: days[index],
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monthName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Week ${_currentWeekIndex + 1}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _changeWeek(-1);

                      Gaimon.selection();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _changeWeek(1);
                      Gaimon.selection();
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class _BarChartItem extends StatelessWidget {
  final int value;
  final String day;

  const _BarChartItem({
    required this.value,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    double maxBarHeight = 100.0; // Maximum height of the bar

    return Column(
      mainAxisAlignment: MainAxisAlignment.end, // Align bars at the bottom
      children: [
        Container(
          height: value > 0
              ? (value / 10 * maxBarHeight).clamp(10.0, maxBarHeight)
              : 10.0,
          width: 16,
          decoration: BoxDecoration(
            color: AppTheme.primary, // Bar color
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
