import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;

  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      color: backgroundColor,
      onPressed: onPressed,
      textColor: textColor,
      child: Text(text),
    );
  }
}
