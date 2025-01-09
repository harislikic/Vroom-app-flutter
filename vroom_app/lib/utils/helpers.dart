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

String FormatRemainingTime(DateTime expiryDate) {
  final now = DateTime.now();
  final difference = expiryDate.difference(now);

  final days = difference.inDays;
  final hours = difference.inHours % 24;
  final minutes = difference.inMinutes % 60;

  if (days > 0) {
    return 'Izdvojen još $days ${days == 1 ? 'dan' : 'dana'} i $hours ${hours == 1 ? 'sat' : 'sata'}.';
  } else if (hours > 0) {
    return 'Izdvojen još $hours ${hours == 1 ? 'sat' : 'sata'} i $minutes ${minutes == 1 ? 'minut' : 'minuta'}.';
  } else {
    return 'Izdvojen još $minutes ${minutes == 1 ? 'minut' : 'minuta'}.';
  }
}
