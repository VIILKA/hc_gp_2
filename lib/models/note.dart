import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String feeling;

  @HiveField(1)
  String text;

  Note({
    required this.feeling,
    required this.text,
  });
}
