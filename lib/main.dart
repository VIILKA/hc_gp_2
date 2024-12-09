import 'package:flutter/material.dart';
import 'package:hc_gp_2/initial_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hc_gp_2/models/feeling.dart';
import 'package:hc_gp_2/models/goal.dart';
import 'package:hc_gp_2/models/note.dart';
import 'package:hc_gp_2/models/training.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TrainingAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(FeelingAdapter());

  await Hive.openBox<Training>('trainings');
  await Hive.openBox<Goal>('goals');
  await Hive.openBox<Feeling>('feelings');
  await Hive.openBox('settings');

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'PeakProgress Win',
        debugShowCheckedModeBanner: false,
        home: InitialPage());
  }
}
