import 'package:flutter/material.dart';
import '../../models/automobileAdEquipment.dart';

class CarAdditionalEquipmentCard extends StatelessWidget {
  final List<AutomobileAdEquipment> automobileAdEquipments;

  const CarAdditionalEquipmentCard({Key? key, required this.automobileAdEquipments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (automobileAdEquipments.isEmpty) {
      return const SizedBox();
    }
    return Card(
      elevation: 2, // Blago izdizanje kako bi se kartica istaknula
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Zaobljeni rubovi za ugodniji izgled
      ),
      margin: const EdgeInsets.symmetric(vertical: 16.0), // Održavanje vertikalnog razmaka
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Razmak unutar kartice
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Naslov kartice
            const Text(
              'Dodatna oprema:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Dodaje boju naslovu
              ),
            ),
            const SizedBox(height: 8),

            // Lista dodatne opreme s ikonom
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: automobileAdEquipments.map((equipment) {
                return Container(
                  padding: const EdgeInsets.all(8.0), // Dodaj padding za bolji izgled
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Zaobljeni rubovi za svaki element
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle, // Promijenjena ikona u check_circle
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        equipment.equipment.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // Dodaje debljinu teksta
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
