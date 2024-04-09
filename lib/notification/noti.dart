import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:time_planner_app/data/data_class/toDo.dart';
import 'package:time_planner_app/main.dart';

class Noti {
  void scheduleAlarm(DateTime dateTime, ToDo toDo) async {
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
        // dateTime.year,
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
        final uniqueNotificationId = UniqueKey().hashCode;

        await flutterLocalNotificationsPlugin.zonedSchedule(
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
      }
    } catch (e) {
      print("Error occured while getting device timeZone: $e");
    }
  }
}
