import 'package:flutter/material.dart';
import '../../models/automobileAd.dart';

class CarDetailsCard extends StatelessWidget {
  final AutomobileAd automobileAd;

  const CarDetailsCard({Key? key, required this.automobileAd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          automobileAd.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
       
        const SizedBox(height: 8),
        Text(
          'Price: ${automobileAd.price.toStringAsFixed(2)} KM',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
