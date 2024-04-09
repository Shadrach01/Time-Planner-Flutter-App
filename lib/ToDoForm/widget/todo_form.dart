// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:time_planner_app/data/data_class/toDo.dart';
import 'package:time_planner_app/main.dart';
import 'package:time_planner_app/model/time_planner_model.dart';
import 'package:time_planner_app/util/button.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

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

  // void scheduleAlarm(DateTime dateTime, ToDo toDo) async {
  //   tz.initializeTimeZones();
  //   // final deviceTimeZone = tz.local;
  //   // final now = tz.TZDateTime.now(deviceTimeZone);

  //   final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  //   tz.Location? deviceTimeZone;
  //   try {
  //     deviceTimeZone = tz.getLocation(timeZoneName);
  //     print("DEvice location is : $deviceTimeZone");
  //     final now = tz.TZDateTime.now(deviceTimeZone);
  //     print("Device time is : $now");
  //     DateTime selectedTime = tz.TZDateTime(
  //       deviceTimeZone,
  //       // dateTime.year,
  //       now.year,
  //       now.month,
  //       now.day,
  //       now.hour,
  //       now.minute,
  //     );
  //     selectedTime = dateTime;

  //     // final timeZoneOffset = selectedTime.timeZoneOffset;
  //     // selectedTime = selectedTime.add(timeZoneOffset);

  //     AndroidNotificationDetails androidPlatformChannelSpecifics =
  //         const AndroidNotificationDetails(
  //       'you_can_name_it_whatever',
  //       'channel_name',
  //       playSound: true,
  //       // sound: RawResourceAndroidNotificationSound('notification'),
  //       importance: Importance.max,
  //       priority: Priority.high,
  //     );

  //     var not = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: const DarwinNotificationDetails(),
  //     );

  //     if (selectedTime.isAfter(now)) {
  //       final timeUntilNotification = selectedTime.difference(now);

  //       // Unique ID/key for each todo Notification
  //       final uniqueNotificationId = UniqueKey().hashCode;

  //       await flutterLocalNotificationsPlugin.zonedSchedule(
  //         uniqueNotificationId,
  //         toDo.todo,
  //         toDo.time.toString(),
  //         tz.TZDateTime.now(deviceTimeZone).add(timeUntilNotification),
  //         not,
  //         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //         uiLocalNotificationDateInterpretation:
  //             UILocalNotificationDateInterpretation.absoluteTime,
  //         matchDateTimeComponents: DateTimeComponents.dateAndTime,
  //       );
  //     }
  //   } catch (e) {
  //     print("Error occured while getting device timeZone: $e");
  //   }
  // }

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
