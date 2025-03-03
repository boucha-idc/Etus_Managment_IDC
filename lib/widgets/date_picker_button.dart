import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerButton extends StatelessWidget {
  final String title;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateChanged;

  DatePickerButton({
    required this.title,
    this.initialDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (initialDate == null) return;

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate!,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          onDateChanged(pickedDate);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              initialDate != null
                  ? DateFormat('yyyy-MM-dd').format(initialDate!)
                  : "Pick a date",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.grey,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
