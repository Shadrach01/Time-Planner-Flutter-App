import 'package:flutter/material.dart';
import 'package:time_planner_app/ToDoForm/widget/todo_form.dart';
import 'package:time_planner_app/data/data_class/toDo.dart';

class TodoEditPage extends StatelessWidget {
  final ToDo editedTodo;

  const TodoEditPage({
    super.key,
    required this.editedTodo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EDIT TODO",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: TodoForm(
        editedTodo: editedTodo,
      ),
    );
  }
}
