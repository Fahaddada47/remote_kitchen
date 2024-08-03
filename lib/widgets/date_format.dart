import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormattedDate extends StatelessWidget {
  final String date;
  final String label;

  const FormattedDate({Key? key, required this.date, required this.label}) : super(key: key);

  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('MMMM d, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(formatDate(date)),
      ],
    );
  }
}
