// widgets/add_feeling_sheet.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hive/hive.dart';
import 'package:hc_gp_2/models/feeling.dart';
import 'package:hc_gp_2/styles/app_theme.dart';

class AddFeelingSheet extends StatefulWidget {
  final Feeling? existingFeeling;

  const AddFeelingSheet({Key? key, this.existingFeeling}) : super(key: key);

  @override
  State<AddFeelingSheet> createState() => _AddFeelingSheetState();
}

class _AddFeelingSheetState extends State<AddFeelingSheet> {
  final _formKey = GlobalKey<FormState>();
  String mood = '';
  String description = '';

  @override
  void initState() {
    super.initState();
    if (widget.existingFeeling != null) {
      mood = widget.existingFeeling!.mood;
      description = widget.existingFeeling!.description;
    }
  }

  void _saveFeeling() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      DateTime today = DateTime.now();
      var box = Hive.box<Feeling>('feelings');

      // Проверка существования настроения для сегодняшнего дня
      int existingIndex = box.values.toList().indexWhere(
            (feeling) =>
                feeling.date.year == today.year &&
                feeling.date.month == today.month &&
                feeling.date.day == today.day,
          );

      if (existingIndex != -1) {
        // Обновление существующего настроения
        Feeling existingFeeling = box.getAt(existingIndex)!;
        existingFeeling.mood = mood;
        existingFeeling.description = description;
        await existingFeeling.save();
      } else {
        // Добавление нового настроения
        Feeling newFeeling = Feeling(
          date: today,
          mood: mood,
          description: description,
        );
        await box.add(newFeeling);
      }

      // Закрытие нижнего листа
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Полоска для перетаскивания
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.existingFeeling == null
                ? "How are you feeling today?"
                : "Edit Your Feeling",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Поле ввода настроения
                  TextFormField(
                    initialValue: mood,
                    decoration: InputDecoration(
                      labelText: 'Mood',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSaved: (value) {
                      mood = value ?? '';
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your mood'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Поле ввода описания настроения
                  TextFormField(
                    initialValue: description,
                    decoration: InputDecoration(
                      labelText: 'Why do you feel this way?',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 4,
                    style: TextStyle(color: Colors.white),
                    onSaved: (value) {
                      description = value ?? '';
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a description'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Кнопка сохранения настроения
                  ElevatedButton(
                    onPressed: () {
                      _saveFeeling.call();
                      Gaimon.selection();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 16),
                    ),
                    child: Text(
                      widget.existingFeeling == null
                          ? "Save Feeling"
                          : "Update Feeling",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
