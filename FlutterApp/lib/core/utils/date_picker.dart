import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> pickDateTime(BuildContext context) async {
  final DateTime now = DateTime.now();
  final DateTime tomorrow = now.add(Duration(days: 1));

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: tomorrow,
    firstDate: tomorrow,
    lastDate: DateTime(2100),
  );

  if (pickedDate == null) return null;

  final TimeOfDay initialTime =
      TimeOfDay(hour: tomorrow.hour, minute: tomorrow.minute);

  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );

  if (pickedTime == null) return null;

  final DateTime finalDateTime = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );

  return DateFormat('dd-MM-yyyy \'At\' hh:mma').format(finalDateTime);
}
