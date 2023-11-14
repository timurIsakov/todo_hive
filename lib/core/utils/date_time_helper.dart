import 'package:flutter/material.dart';

class DateTimeHelper {
  static Future<DateTime?> getDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final TimeOfDay currentTime = TimeOfDay.now();

    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
    );

    if (newDate != null) {
      final DateTime newDateTime = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        currentTime.hour,
        currentTime.minute,
      );
      return newDateTime;
    }

    return null;
  }
}
