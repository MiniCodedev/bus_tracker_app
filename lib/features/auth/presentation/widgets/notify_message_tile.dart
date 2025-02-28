import 'package:bus_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NotifyMessageTile extends StatelessWidget {
  final String text;
  const NotifyMessageTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(
              Icons.info,
              color: AppColors.primaryColor,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
