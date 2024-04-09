import 'package:flutter/material.dart';
import 'package:time_planner_app/util/sliding_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Achieve your goals,',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 15),
              const Text(
                'Effortlesly manage your to-do list and take control of your day',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 140, 0),
                child: slidingButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
