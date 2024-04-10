import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:time_planner_app/data/data_class/toDo.dart';
import 'package:time_planner_app/model/time_planner_model.dart';
import 'package:time_planner_app/util/button.dart';

class TodoForm extends StatefulWidget {
  final ToDo? editedTodo;

  const TodoForm({
    super.key,
    this.editedTodo,
  });

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();

  late String _todo;

  var hour = 0;
  var minute = 0;
  var timeFormat = 'AM';

  // Initial date
  DateTime _dateTime = DateTime.now();

  bool get isEditMode => widget.editedTodo != null;

  Duration duration = const Duration();

  @override
  Widget build(BuildContext context) {
    // Format the DateTime to show only the time
    String formattedTime = DateFormat('hh:mm a').format(_dateTime);

    // Format the DateTime to show only the date
    String formattedDate = DateFormat('dd-MM-yyy').format(_dateTime);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Column(
            children: [
              TextFormField(
                onSaved: (value) => _todo = value!,
                initialValue: widget.editedTodo?.todo,
                decoration: InputDecoration(
                  labelText: 'Type your ToDo here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              Text(
                isEditMode
                    ? widget.editedTodo?.todoDate.toString() ?? formattedDate
                    : formattedDate,
                style: const TextStyle(fontSize: 40),
              ),
              Button(
                  text: 'Select Date',
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    _showDatePicker(context);
                  }),
              Text(
                isEditMode
                    ? widget.editedTodo?.time.toString() ?? formattedTime
                    : formattedTime,
                style: const TextStyle(fontSize: 40),
              ),

              // ),
              Button(
                text: 'Select Time',
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  _showTimePicker(context);
                },
              ),

              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  _onSaveButtonClicked();
                },
                height: 50,
                color: Colors.black,
                textColor: Colors.white,
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Show the time picker popup
  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: ((context) {
        return Center(
          child: SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              backgroundColor: Colors.white,
              initialDateTime: _dateTime,
              maximumYear: DateTime.now().year,
              minimumYear: DateTime.now().year,
              maximumDate:
                  DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (newDate) {
                setState(() {
                  _dateTime = newDate;
                });
              },
            ),
          ),
        );
      }),
    );
  }

  // Show the time picker popup
  void _showTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: ((context) {
        return Center(
          child: SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              backgroundColor: Colors.white,
              initialDateTime: _dateTime,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (newTime) {
                setState(() {
                  _dateTime = newTime;
                });
              },
            ),
          ),
        );
      }),
    );
  }

  // Function for when the save button has been clicked
  void _onSaveButtonClicked() {
    final scopedModel = ScopedModel.of<TimePlannerModel>(context);
    // Format the DateTime to show only the time
    String formattedTime = DateFormat('hh:mm a').format(_dateTime);

    DateTime selectedTime = _dateTime;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final String updatedRemainingTime =
          scopedModel.calculateRemainingTime(selectedTime, widget.editedTodo);
      final newOrEditedToDo = ToDo(
        todo: _todo,
        todoDate: selectedTime.day,
        time: formattedTime,
        timeLeft: updatedRemainingTime,

        // percentageRemaining: "60%",
      );
      if (isEditMode) {
        newOrEditedToDo.id = widget.editedTodo!.id;
        scopedModel.updateTodo(newOrEditedToDo);
      } else {
        scopedModel.addToDo(newOrEditedToDo);
      }
      Navigator.of(context).pop();
      scopedModel.noti.scheduleAlarm(selectedTime, newOrEditedToDo);
    }
  }
}
