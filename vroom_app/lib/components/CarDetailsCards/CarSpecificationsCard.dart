import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/automobileAd.dart';

class CarSpecificationsCard extends StatelessWidget {
  final AutomobileAd automobileAd;

  const CarSpecificationsCard({Key? key, required this.automobileAd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final formatter = NumberFormat.decimalPattern('de');
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        InfoColumn(icon: Icons.calendar_today, label: 'Godina', value: '${automobileAd.yearOfManufacture}'),
  InfoColumn(
          icon: Icons.speed,
          label: 'Kilometraža',
          value: '${formatter.format(automobileAd.mileage)} km',
        ),
        InfoColumn(icon: Icons.local_gas_station, label: 'Gorivo', value: automobileAd.fuelType?.name ?? '-'),
        InfoColumn(icon: Icons.directions_car, label: 'Transmisija', value: automobileAd.transmissionType?.name ?? '-'),
        InfoColumn(icon: Icons.color_lens, label: 'Boja', value: automobileAd.color ?? '-'),
        InfoColumn(icon: Icons.door_front_door, label: 'Vrata', value: automobileAd.numberOfDoors.toString()),
        InfoColumn(icon: Icons.power, label: 'Konjskih snaga (HP)', value: automobileAd.horsePower.toString()),
        InfoColumn(icon: Icons.engineering, label: 'Kubikaža', value: automobileAd.cubicCapacity.toString()),
        InfoColumn(icon: Icons.directions_car_filled, label: 'Model', value: automobileAd.carModel?.name ?? '-'),
        InfoColumn(icon: Icons.branding_watermark, label: 'Brend', value: automobileAd.carBrand?.name ?? '-'),
        InfoColumn(icon: Icons.category, label: 'Kategorija', value: automobileAd.carCategory?.name ?? '-'),
      ],
    );
  }
}

// Definicija InfoColumn komponente u istoj datoteci s pozadinom
class InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoColumn({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0), // Dodaje malo prostora unutar elemenata
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50, // Dodaje pozadinsku boju
        borderRadius: BorderRadius.circular(10), // Zaobljeni rubovi za karticu
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
