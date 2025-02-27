import 'package:bus_tracker_app/core/assets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleButton extends StatelessWidget {
  final void Function() onPressed;
  final double width;
  const GoogleButton(
      {super.key, this.width = double.maxFinite, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          fixedSize: WidgetStatePropertyAll(Size(width, 50)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ))),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppSvg.googleSvg),
            SizedBox(
              width: 15,
            ),
            Text("Continue with Google")
          ],
        ),
      ),
    );
  }
}
