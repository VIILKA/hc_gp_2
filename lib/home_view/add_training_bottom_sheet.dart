import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hc_gp_2/models/goal.dart';
import 'package:hc_gp_2/models/training.dart';
import 'package:hc_gp_2/styles/app_theme.dart';

class AddTrainingBottomSheet extends StatefulWidget {
  final Training? training;
  final VoidCallback? onSave;

  const AddTrainingBottomSheet({super.key, this.training, this.onSave});

  @override
  _AddTrainingBottomSheetState createState() => _AddTrainingBottomSheetState();
}

class _AddTrainingBottomSheetState extends State<AddTrainingBottomSheet> {
  late String selectedCategory; // Selected category
  late String intensity; // Selected intensity
  late TextEditingController descriptionController;
  late String durationMinutes;
  late String durationHours;
  late String caloriesBurned;

  final List<Map<String, String>> categories = [
    {"label": "Running", "icon": "directions_run"},
    {"label": "Cycling", "icon": "pedal_bike"},
    {"label": "Swimming", "icon": "pool"},
    {"label": "Yoga", "icon": "self_improvement"},
    {"label": "Squats", "icon": "directions_walk"},
    {"label": "Lunges", "icon": "accessibility_new"},
    {"label": "Deadlifts", "icon": "fitness_center"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.training != null) {
      // Editing an existing training
      selectedCategory = widget.training!.category;
      intensity = widget.training!.intensity;
      descriptionController =
          TextEditingController(text: widget.training!.description);
      int totalMinutes = widget.training!.durationInMinutes;
      durationHours = (totalMinutes ~/ 60).toString().padLeft(2, '0');
      durationMinutes = (totalMinutes % 60).toString().padLeft(2, '0');
      caloriesBurned = widget.training!.caloriesBurned.toString();
    } else {
      // Adding a new training
      selectedCategory = "Running";
      intensity = "Easy";
      descriptionController = TextEditingController();
      durationMinutes = "00";
      durationHours = "00";
      caloriesBurned = "0";
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _showDurationPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            pickerTextStyle: const TextStyle(
              color: Colors.white, // Белый цвет текста
              fontSize: 22, // Размер текста
              fontWeight: FontWeight.w400, // Жирный шрифт
            ),
          ),
        ),
        child: Container(
          height: 300,
          color: const Color(0xFF2B2B2B), // Цвет фона
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  minuteInterval: 1,
                  initialTimerDuration: Duration(
                    hours: int.tryParse(durationHours) ?? 0,
                    minutes: int.tryParse(durationMinutes) ?? 0,
                  ),
                  onTimerDurationChanged: (Duration changedTimer) {
                    setState(() {
                      durationHours =
                          changedTimer.inHours.toString().padLeft(2, '0');
                      durationMinutes = (changedTimer.inMinutes % 60)
                          .toString()
                          .padLeft(2, '0');
                    });
                  },
                ),
              ),
              // Кнопка "Done"
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Gaimon.selection();
                },
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Rest of your widget code

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2B2B2B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          // Add scrolling for small screens
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.training != null ? "Edit Training" : "Add Training",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Gaimon.selection();
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Categories
              const Text(
                "Select a training category",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 70, // Height of the categories container
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category["label"]!;
                        });
                        Gaimon.selection();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedCategory == category["label"]
                              ? const Color(0xFF6B75FF)
                              : AppTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getIconForCategory(category["icon"]!),
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category["label"]!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Training Description
              const Text(
                "Training Description",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Enter your training description",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Duration and Calories
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      "Duration",
                      "$durationHours h $durationMinutes min",
                      (value) {},
                      onTap: () {
                        _showDurationPicker();
                        Gaimon.selection();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      "Calories burned",
                      caloriesBurned,
                      (value) {
                        setState(() {
                          caloriesBurned = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Intensity
              const Text(
                "Intensity",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildRadioButton("Easy")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRadioButton("Moderate")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRadioButton("Hard")),
                ],
              ),
              const SizedBox(height: 16),
              // Save button
              ElevatedButton(
                onPressed: () async {
                  // Валидация и парсинг данных
                  int hours = int.tryParse(durationHours) ?? 0;
                  int minutes = int.tryParse(durationMinutes) ?? 0;
                  int totalDurationInMinutes = hours * 60 + minutes;

                  int totalCaloriesBurned = int.tryParse(caloriesBurned) ?? 0;

                  bool isNewTraining = widget.training == null;

                  String oldCategory = '';
                  if (!isNewTraining) {
                    oldCategory = widget.training!.category;
                    // Обновление существующей тренировки
                    widget.training!.category = selectedCategory;
                    widget.training!.description = descriptionController.text;
                    widget.training!.durationInMinutes = totalDurationInMinutes;
                    widget.training!.caloriesBurned = totalCaloriesBurned;
                    widget.training!.intensity = intensity;
                    await widget.training!.save();

                    // Если категория изменилась, обновляем прогресс целей
                    if (oldCategory != selectedCategory) {
                      var goalBox = Hive.box<Goal>('goals');

                      // Уменьшаем прогресс целей с предыдущей категорией
                      List<Goal> oldGoals = goalBox.values
                          .where((goal) => goal.category == oldCategory)
                          .toList();
                      for (var goal in oldGoals) {
                        goal.decrementProgress();
                      }

                      // Увеличиваем прогресс целей с новой категорией
                      List<Goal> newGoals = goalBox.values
                          .where((goal) => goal.category == selectedCategory)
                          .toList();
                      for (var goal in newGoals) {
                        goal.incrementProgress();
                      }
                    }
                  } else {
                    // Создание новой тренировки
                    Training newTraining = Training(
                      category: selectedCategory,
                      description: descriptionController.text,
                      date: DateTime.now(),
                      durationInMinutes: totalDurationInMinutes,
                      caloriesBurned: totalCaloriesBurned,
                      intensity: intensity,
                      notes: [],
                    );

                    var box = await Hive.openBox<Training>('trainings');
                    await box.add(newTraining);

                    // Обновление прогресса целей
                    var goalBox = Hive.box<Goal>('goals');

                    // Поиск целей, соответствующих категории тренировки
                    List<Goal> matchingGoals = goalBox.values
                        .where((goal) => goal.category == newTraining.category)
                        .toList();

                    for (var goal in matchingGoals) {
                      goal.incrementProgress();
                    }
                  }

                  Navigator.pop(context, true);

                  if (widget.onSave != null) {
                    widget.onSave!();
                  }
                  Gaimon.selection();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B75FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                  child: Text(
                    widget.training != null ? "Save Changes" : "Save",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Date
              Center(
                child: Text(
                  DateFormat('MMM dd, yyyy').format(DateTime.now()),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build radio buttons
  Widget _buildRadioButton(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          intensity = label;
        });
        Gaimon.selection();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: intensity == label
              ? Border.all(color: AppTheme.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: intensity == label
                  ? AppTheme.primary
                  : const Color.fromARGB(146, 255, 255, 255),
            ),
          ),
        ),
      ),
    );
  }

  // Method to create input fields
  Widget _buildInputField(
      String label, String value, ValueChanged<String> onChanged,
      {VoidCallback? onTap}) {
    TextEditingController? controller;
    if (onTap == null) {
      controller = TextEditingController(text: value);
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          readOnly: onTap != null,
          onTap: () {
            onTap;
            Gaimon.selection();
          },
          keyboardType:
              onTap == null ? TextInputType.number : TextInputType.none,
          controller: controller,
          decoration: InputDecoration(
            hintText: value,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: AppTheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Method to get icon by name
  IconData _getIconForCategory(String iconName) {
    switch (iconName) {
      case "directions_run":
        return Icons.directions_run;
      case "pedal_bike":
        return Icons.pedal_bike;
      case "pool":
        return Icons.pool;
      case "self_improvement":
        return Icons.self_improvement;
      case "directions_walk":
        return Icons.directions_walk;
      case "accessibility_new":
        return Icons.accessibility_new;
      case "fitness_center":
        return Icons.fitness_center;
      default:
        return Icons.help;
    }
  }
}
