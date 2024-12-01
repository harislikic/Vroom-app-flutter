import 'package:flutter/material.dart';
import '../../models/automobileAd.dart';

class CarOwnerInfoCard extends StatelessWidget {
  final AutomobileAd automobileAd;

  const CarOwnerInfoCard({Key? key, required this.automobileAd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Posted by: ${automobileAd.user.firstName} ${automobileAd.user.lastName}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          'Contact: ${automobileAd.user.phoneNumber}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
