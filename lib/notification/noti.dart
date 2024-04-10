import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:time_planner_app/data/data_class/toDo.dart';

class NotificationPlugin {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // A list to hold every unique Id for each alarm scheduled
  List<int> uniqueNotificationIds = [];

  // Funtion to schedule an alarm
  Future<void> scheduleAlarm(DateTime dateTime, ToDo toDo) async {
    tz.initializeTimeZones();

    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.Location? deviceTimeZone;
    try {
      // Get the exact location of the device
      deviceTimeZone = tz.getLocation(timeZoneName);

      // Get the current time of the device
      final now = tz.TZDateTime.now(deviceTimeZone);

      DateTime selectedTime = tz.TZDateTime(
        deviceTimeZone,
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );

      selectedTime = dateTime;
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          const AndroidNotificationDetails(
        'time_planner_notification',
        'todo_notification_channel',
        playSound: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high,
      );

      var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );

      if (selectedTime.isAfter(now)) {
        final timeUntilNotification = selectedTime.difference(now);

        // Unique ID/key for each todo Notification
        int uniqueNotificationId = UniqueKey().hashCode;

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          uniqueNotificationId,
          toDo.todo,
          toDo.time.toString(),
          tz.TZDateTime.now(deviceTimeZone).add(timeUntilNotification),
          not,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );

        // Add the alarm Id to the list of Ids
        uniqueNotificationIds.add(uniqueNotificationId);
      }
    } catch (e) {
      // Catch the error
    }
  }

  // Function to cancel the alarm
  Future<void> cancelAlarm(int index) async {
    // Locate the index of the alarm that's ot be canceled using the Todo list index
    if (index >= 0 && index < uniqueNotificationIds.length) {
      int uniqueNotificationId = uniqueNotificationIds[index];
      await _flutterLocalNotificationsPlugin.cancel(uniqueNotificationId);

      // remove the already canceled alarm uniqueId from the list
      uniqueNotificationIds.removeAt(index);
    }
  }
}
