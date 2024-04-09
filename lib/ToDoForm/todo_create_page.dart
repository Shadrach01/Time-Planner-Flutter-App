import 'package:flutter/material.dart';
import 'package:time_planner_app/ToDoForm/widget/todo_form.dart';

class TodoCreatePage extends StatelessWidget {
  const TodoCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ADD NEW TODO",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: const TodoForm(),
    );
  }
}
