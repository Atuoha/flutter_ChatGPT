import 'package:flutter/material.dart';

import '../../constants/enums/status.dart';
import '../constants/colors.dart';

void displaySnackBar({
  required Status status,
  required String message,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: status == Status.success ? primaryColor : Colors.red,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          Icon(
            status == Status.success
                ? Icons.mood
                : Icons.sentiment_dissatisfied,
            color:Colors.white,
          )
        ],
      ),
    ),
  );
}
