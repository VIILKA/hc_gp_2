import 'package:hive/hive.dart';
import 'package:hc_gp_2/models/note.dart';

part 'training.g.dart';

@HiveType(typeId: 0)
class Training extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  int durationInMinutes; // Store total duration in minutes

  @HiveField(4)
  int caloriesBurned;

  @HiveField(5)
  String intensity;

  @HiveField(6)
  List<Note> notes;

  Training({
    required this.category,
    required this.description,
    required this.date,
    required this.durationInMinutes,
    required this.caloriesBurned,
    required this.intensity,
    required this.notes,
  });
}
