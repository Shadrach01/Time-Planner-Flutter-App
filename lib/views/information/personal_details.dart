import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:time_planner_app/data/data_class/user_data.dart';
import 'package:time_planner_app/model/time_planner_model.dart';
import 'package:time_planner_app/util/button.dart';
import 'package:time_planner_app/views/todo_list_page.dart';
import 'package:time_planner_app/views/welcome_screen.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
// Form key
  final _formKey = GlobalKey<FormState>();

  late String _userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Enter your name to proceed',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) => _userName = value!,
                  validator: _validateUserName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Input your name',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Button(
                  text: 'Save',
                  backgroundColor: Colors.deepOrange[300],
                  onPressed: _onSaveButtonClicked,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateUserName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  void _onSaveButtonClicked() {
    final scopedModel = ScopedModel.of<TimePlannerModel>(context);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final newUsername = UserData(userName: _userName);
      scopedModel.addUserName(newUsername);

      final route =
          MaterialPageRoute(builder: (context) => const ToDoListPage());
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  }
}
