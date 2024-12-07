import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl/intl.dart';
import 'package:hc_gp_2/models/training.dart';
import 'package:hc_gp_2/models/note.dart';
import 'package:hc_gp_2/styles/app_theme.dart';
import 'package:hc_gp_2/home_view/add_note.dart';
import 'package:hc_gp_2/home_view/add_training_bottom_sheet.dart';

class OpenTrainingPage extends StatefulWidget {
  final Training training;

  const OpenTrainingPage({super.key, required this.training});

  @override
  State<OpenTrainingPage> createState() => _OpenTrainingPageState();
}

class _OpenTrainingPageState extends State<OpenTrainingPage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    notes = widget.training.notes;
  }

  void showAddNoteBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.65,
        minChildSize: 0.3,
        builder: (_, controller) => AddNoteBottomSheet(),
      ),
    );

    if (result != null) {
      Note newNote = Note(
        feeling: result['feeling'] ?? '',
        text: result['note'] ?? '',
      );

      setState(() {
        notes.add(newNote);
        widget.training.notes = notes;
        widget.training.save();
      });
    }
  }

  void _showEditTrainingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.7,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: AddTrainingBottomSheet(
                training: widget.training,
                onSave: () {
                  setState(() {
                    // Update UI after editing
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteTraining(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: const Color(0xFF1C1C1E), // Темный фон
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Кнопка закрытия
              Align(
                alignment: Alignment.topRight,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.of(context).pop();

                    Gaimon.selection();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Основной текст
              const Text(
                "Do you want to delete the current activity?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Кнопки действия
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Кнопка "Cancel"
                  Expanded(
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      onPressed: () {
                        Navigator.of(context).pop();

                        Gaimon.selection();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Кнопка "Delete"
                  Expanded(
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      onPressed: () {
                        widget.training.delete();
                        Navigator.of(context).pop(); // Закрываем диалог
                        Navigator.of(context).pop(true);
                        Gaimon.selection(); // Обновляем список
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteNoteAt(int index) {
    setState(() {
      notes.removeAt(index);
      widget.training.notes = notes;
      widget.training.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final training = widget.training;
    // Format date
    String formattedDate = DateFormat('MMM dd, yyyy').format(training.date);
    // Format duration
    int hours = training.durationInMinutes ~/ 60;
    int minutes = training.durationInMinutes % 60;
    String duration = "$hours h $minutes min";

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
            Gaimon.selection();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          // Add scrolling
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and icon
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconForCategory(training.category),
                        color: AppTheme.onPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        training.category,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    training.description,
                    style: const TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Date
                  Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStatRow(
                      context,
                      icon: Icons.timer,
                      label: 'Duration',
                      value: duration,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStatRow(
                      context,
                      icon: Icons.local_fire_department,
                      label: 'Calories Burned',
                      value: '${training.caloriesBurned} kcal',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Notes',
                style: TextStyle(
                  color: AppTheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              notes.isNotEmpty
                  ? Column(
                      children: List.generate(notes.length, (index) {
                        final note = notes[index];
                        return NoteCard(
                          note: note,
                          onDelete: () => _deleteNoteAt(index),
                        );
                      }),
                    )
                  : Container(
                      height: 150,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/images/154d74b6773b89172b69933d16bf8e6a.png')),
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            color: const Color.fromARGB(108, 0, 0, 0),
                          ),
                          Center(
                            child: Text(
                              "You don't have any notes added",
                              style: AppTheme.bodyMedium
                                  .copyWith(color: AppTheme.onPrimary),
                            ),
                          )
                        ],
                      ),
                    ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // "Edit" and "Delete" with a dividing line
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildCustomButton(
                              context,
                              icon: Icons.edit,
                              label: 'Edit',
                              color: Colors.white,
                              iconColor: Colors.blue,
                              labelColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              onPressed: () {
                                _showEditTrainingBottomSheet(context);
                                Gaimon.selection();
                              },
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: const Color.fromARGB(158, 231, 230, 228),
                          ),
                          Expanded(
                            child: _buildCustomButton(
                              context,
                              icon: Icons.delete,
                              label: 'Delete',
                              color: Colors.white,
                              iconColor: Colors.red,
                              labelColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              onPressed: () {
                                _confirmDeleteTraining(context);
                                Gaimon.selection();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // "Add note" button
                    _buildCustomButton(
                      context,
                      icon: Icons.note_add,
                      label: 'Add note',
                      color: Colors.white,
                      iconColor: Colors.white,
                      labelColor: Colors.white,
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        showAddNoteBottomSheet(context);
                        Gaimon.selection();
                      },
                      isRounded: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.onPrimary, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: AppTheme.onPrimary, fontSize: 16),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
                color: AppTheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required Color labelColor,
    required Color backgroundColor,
    required VoidCallback onPressed,
    bool isRounded = false,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        onPressed.call();
        Gaimon.selection();
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(isRounded ? 24 : 12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTheme.labelLarge.copyWith(color: AppTheme.secondary),
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

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;

  const NoteCard({super.key, required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Верхняя строка с "Feeling" и кнопкой удаления
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Feeling",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.feeling,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CupertinoButton(
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Разделительная линия
          Divider(color: Colors.grey[700], thickness: 1),
          const SizedBox(height: 8),
          // Текст заметки
          Text(
            note.text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
