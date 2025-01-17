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

String formatPrice(double? price) {
  if (price == null) return 'Nema cijenu';
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  return '${formatter.format(price)} KM';
}

String formatPhoneNumber(String phoneNumber) {
  final RegExp regex = RegExp(r'(\+\d{3})(\d{2})(\d{3})(\d{3})');
  final Match? match = regex.firstMatch(phoneNumber);

  if (match != null) {
    final String countryCode = match.group(1) ?? '';
    final String areaCode = match.group(2) ?? '';
    final String firstPart = match.group(3) ?? '';
    final String secondPart = match.group(4) ?? '';
    return '$countryCode $areaCode $firstPart-$secondPart';
  }
  return phoneNumber;
}
