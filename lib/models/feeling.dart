// models/feeling.dart

import 'package:hive/hive.dart';

part 'feeling.g.dart';

@HiveType(typeId: 3)
class Feeling extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String mood;

  @HiveField(2)
  String description;

  Feeling({
    required this.date,
    required this.mood,
    required this.description,
  });
}
