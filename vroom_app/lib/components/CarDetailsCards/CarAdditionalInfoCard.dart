import 'package:flutter/material.dart';
import '../../models/automobileAd.dart';
import 'package:intl/intl.dart';

class CarAdditionalInfoCard extends StatelessWidget {
  final AutomobileAd automobileAd;

  const CarAdditionalInfoCard({Key? key, required this.automobileAd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd.MM.yyyy').format(automobileAd.dateOfAdd);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Info Row (Date Added, Views)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Datum dodavanja: $formattedDate',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility,
                      size: 20,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${automobileAd.viewsCount}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Registered Status
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Aligns them properly in a row
              children: [
                // Registered Status
                Row(
                  children: [
                    const Icon(
                      Icons
                          .car_repair, // Better representation of vehicle registration
                      size: 20,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Registrovan:',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(width: 8),
                    if (automobileAd.registered)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      )
                    else
                      const Icon(
                        Icons.cancel, // Red "X" icon to indicate not registered
                        color: Colors.red,
                        size: 20,
                      ),
                  ],
                ),
                // Condition Information
                Row(
                  children: [
                    const Icon(
                      Icons.car_rental, // Better icon for vehicle condition
                      size: 20,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Stanje: ${automobileAd.vehicleCondition?.name ?? '-'}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Other Date Related Info (Grouped)
            if (automobileAd.registrationExpirationDate != null ||
                automobileAd.featuredExpiryDate != null ||
                automobileAd.lastSmallService != null ||
                automobileAd.lastBigService != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (automobileAd.registrationExpirationDate != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Registracija ističe: ${DateFormat('dd.MM.yyyy').format(automobileAd.registrationExpirationDate!)}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  if (automobileAd.lastSmallService != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.build_circle_outlined,
                          size: 20,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Zadnji Mali servis: ${DateFormat('dd.MM.yyyy').format(automobileAd.lastSmallService!)}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  if (automobileAd.lastBigService != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.build,
                          size: 20,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Zadnji veliki servis: ${DateFormat('dd.MM.yyyy').format(automobileAd.lastBigService!)}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
