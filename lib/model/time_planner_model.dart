import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:time_planner_app/data/data_class/user_data.dart';
import 'package:time_planner_app/data/db/time_planner_dao.dart';
import 'package:time_planner_app/data/data_class/toDo.dart';

import 'package:time_planner_app/notification/noti.dart';

class TimePlannerModel extends Model {
  // Instantiate the TimePlannerDao
  final TimePlannerDao _timePlannerDao = TimePlannerDao();

  //Instantiate the Notification class
  final NotificationPlugin _noti = NotificationPlugin();
  NotificationPlugin get noti => _noti;

  // Generater diffferent colors to assign to each tile at random
  static Color generateRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  // Private field to hold
  // the todos
  late List<ToDo> _toDos;

  /* 
    Get only property, makes sure that we cannot overwrite todos
    from different class
  */
  List<ToDo> get toDos => _toDos;

  // Private field to hold
  // the userName
  late UserData _userData;

  // Get method for the userName
  UserData get userData => _userData;

  bool _userNameLoaded = false;
  bool get usernameLoaded => _userNameLoaded;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future addUserName(UserData userName) async {
    await _timePlannerDao.addUserName(userName);
    _userData = userName;
    _userNameLoaded = true;
    notifyListeners();
  }

  Future loadTodos(int selectedDate) async {
    _isLoading = true;
    notifyListeners();
    _toDos = await _timePlannerDao.getTodosForDate(selectedDate);

    // As soon as contacts are loaded, let listeners know
    _isLoading = false;
    notifyListeners();
  }

  // Function to add new Todo to the List
  Future addToDo(ToDo todo) async {
    await _timePlannerDao.insert(todo);
    await loadTodos(todo.todoDate);
    notifyListeners();
  }

  // Function to update the editedTodo
  Future updateTodo(ToDo todo) async {
    await _timePlannerDao.update(todo);
    await loadTodos(todo.todoDate);
    notifyListeners();
  }

  // Function to delete any todo
  Future deleteTodo(ToDo todo) async {
    await _timePlannerDao.delete(todo);
    await loadTodos(todo.todoDate);
    notifyListeners();
  }

  // Calculate the timeLeft base on time given
  String calculateRemainingTime(DateTime dateTime, ToDo? toDo) {
    final now = DateTime.now();
    final selectedTime = DateTime(
      now.year,
      now.month,
      now.day,
      dateTime.hour,
      dateTime.minute,
    );

    final updatedTime = selectedTime.add(
      const Duration(minutes: 1),
    );

    if (updatedTime.isBefore(now)) {
      toDo?.timeLeft = "Time passed";

      return "Time passed";
    }
    final updatedRemainingTime = selectedTime.difference(now);
    final hoursLeft = updatedRemainingTime.inHours;
    final minutesLeft = updatedRemainingTime.inMinutes;

    final newTimeLeft = hoursLeft > 0
        ? "$hoursLeft ${hoursLeft == 1 ? 'hour' : 'hours'}"
        : "$minutesLeft ${minutesLeft <= 1 ? 'minute' : 'minutes'}";

    toDo?.timeLeft = newTimeLeft;
    return newTimeLeft;
  }
}
