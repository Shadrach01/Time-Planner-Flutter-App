import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerDialogBox extends StatelessWidget {
  const TimePickerDialogBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        child: CupertinoDatePicker(
          backgroundColor: Colors.black,
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (_) {},
        ),
      ),
    );
  }
}
