import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:time_planner_app/ToDoForm/widget/todo_form.dart';
import 'package:time_planner_app/model/time_planner_model.dart';
import 'package:time_planner_app/notification/noti.dart';
import 'package:time_planner_app/views/todo_list_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time_planner_app/views/welcome_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime currentDate = DateTime.now();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: TimePlannerModel()..loadTodos(currentDate.day),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ToDoListPage(),
      ),
    );
  }
}
