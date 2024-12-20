import 'package:intl/intl.dart';

String formatDate(String? date) {
  if (date == null) return "N/A";
  try {
    final parsedDate = DateTime.parse(date);
    return DateFormat("dd.MM.yyyy").format(parsedDate);
  } catch (_) {
    return "N/A";
  }
}