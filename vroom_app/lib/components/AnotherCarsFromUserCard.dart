import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vroom_app/services/config.dart';
import '../models/automobileAd.dart';
import '../screens/automobileDetailsScreen.dart';

class AnotherCarsFromUserCard extends StatelessWidget {
  final AutomobileAd automobileAd;

  const AnotherCarsFromUserCard({
    Key? key,
    required this.automobileAd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AutomobileDetailsScreen(automobileAdId: automobileAd.id),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slika automobila sa brojem pregleda
            Stack(
              children: [
                if (automobileAd.images.isNotEmpty)
                  Image.network(
                    '$baseUrl${automobileAd.images.first.imageUrl}',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    height: 140,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.directions_car,
                          size: 40, color: Colors.grey),
                    ),
                  ),
                // Broj pregleda (pozadina sa opacitetom)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.4), // Pozadina sa opacitetom
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${automobileAd.viewsCount}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Naslov i dodatne informacije
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Naslov
                  Row(
                    children: [
                      const Icon(Icons.title, size: 18, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          automobileAd.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Cena
                  Row(
                    children: [
                      const Icon(Icons.attach_money,
                          size: 18, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        '${NumberFormat('#,##0').format(automobileAd.price)} KM',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Datum objave
                  Row(
                    children: [
                      const Icon(Icons.date_range,
                          size: 18, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text(
                        'Datum: ${DateFormat('dd.MM.yyyy').format(automobileAd.dateOfAdd)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.speed,
                          size: 18,
                          color: Colors.blueGrey), // Ikona za kilometražu
                      const SizedBox(width: 4), // Razmak između ikone i teksta
                      Text(
                        '${NumberFormat('###,###', 'en_US').format(automobileAd.mileage).replaceAll(',', '.')} km',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87, // Boja teksta
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
