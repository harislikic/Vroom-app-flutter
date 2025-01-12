import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final void Function(DateTime?) onDatePicked;

  const DatePicker({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDatePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      readOnly: true,
      controller: TextEditingController(
        text: selectedDate == null
            ? ''
            : '${selectedDate!.toLocal()}'.split(' ')[0],
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          onDatePicked(pickedDate);
        }
      },
    );
  }
}
