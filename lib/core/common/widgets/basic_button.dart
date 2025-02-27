import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final double width;
  const BasicButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.width = double.maxFinite});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
          fixedSize: WidgetStatePropertyAll(Size(width, 50)),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(text),
    );
  }
}
