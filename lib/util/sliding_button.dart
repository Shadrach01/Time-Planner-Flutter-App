import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:time_planner_app/views/information/personal_details.dart';

SlideAction slidingButton(BuildContext context) {
  return SlideAction(
    innerColor: Colors.deepOrange[300],
    elevation: 0,
    height: 65,
    sliderButtonIcon: const Icon(
      Icons.arrow_forward,
      color: Colors.white,
    ),
    textStyle: const TextStyle(
      fontSize: 15,
      color: Colors.white,
    ),
    onSubmit: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => PersonalDetails()));
      return null;
    },
    child: const Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 23, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Get Started',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          )
        ],
      ),
    ),
  );
}
