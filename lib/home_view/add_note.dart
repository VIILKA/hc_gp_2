import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hc_gp_2/styles/app_theme.dart';

class AddNoteBottomSheet extends StatefulWidget {
  const AddNoteBottomSheet({super.key});

  @override
  _AddNoteBottomSheetState createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  String selectedFeeling = "";
  final TextEditingController _noteController = TextEditingController();
  final int maxNoteLength = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E), // Темный фон
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхний индикатор
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Заголовок и кнопка закрытия
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add note",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                    Gaimon.selection();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Настроение
            const Text(
              "Feeling",
              style: TextStyle(color: AppTheme.onPrimary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: ["Good", "Normal", "Bad"]
                  .map((feeling) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            feeling,
                            style: TextStyle(
                              color: selectedFeeling == feeling
                                  ? Colors.black
                                  : AppTheme.onPrimary,
                            ),
                          ),
                          selected: selectedFeeling == feeling,
                          selectedColor: AppTheme.primary,
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16), // Скруглённые углы
                            side: BorderSide.none, // Убираем границу
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedFeeling = selected ? feeling : "";
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            // Поле для ввода текста

            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLength: maxNoteLength,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.surface,
                hintText: "Enter your note here",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                counterText: "${_noteController.text.length}/$maxNoteLength",
                counterStyle: const TextStyle(color: Colors.grey),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            // Кнопка сохранения
            Center(
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(20),
                color: AppTheme.primary,
                onPressed: () {
                  if (selectedFeeling.isEmpty || _noteController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, {
                    "feeling": selectedFeeling,
                    "note": _noteController.text,
                  });
                  Gaimon.selection();
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
