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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              'Dodatne informacije o vozilu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const Divider(
              color: Colors.blueGrey,
              thickness: 1.0,
              height: 20,
            ),

            // Datum i pregledi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTile(
                  icon: Icons.calendar_today,
                  label: 'Datum dodavanja',
                  value: formattedDate,
                ),
                _infoTile(
                  icon: Icons.visibility,
                  label: 'Pregledi',
                  value: '${automobileAd.viewsCount}',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Registrovan i stanje vozila
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTileWithIcon(
                  icon: Icons.car_repair,
                  label: 'Registrovan',
                  value: automobileAd.registered
                      ? 'Da'
                      : 'Ne',
                  iconColor: automobileAd.registered
                      ? Colors.green
                      : Colors.red,
                ),
                _infoTile(
                  icon: Icons.car_rental,
                  label: 'Stanje',
                  value: automobileAd.vehicleCondition?.name ?? '-',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ostale informacije vezane za datume
            if (automobileAd.registrationExpirationDate != null ||
                automobileAd.lastSmallService != null ||
                automobileAd.lastBigService != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (automobileAd.registrationExpirationDate != null)
                    _infoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Registracija ističe',
                      value: DateFormat('dd.MM.yyyy')
                          .format(automobileAd.registrationExpirationDate!),
                    ),
                  if (automobileAd.lastSmallService != null)
                    _infoRow(
                      icon: Icons.build_circle_outlined,
                      label: 'Zadnji mali servis',
                      value: DateFormat('dd.MM.yyyy')
                          .format(automobileAd.lastSmallService!),
                    ),
                  if (automobileAd.lastBigService != null)
                    _infoRow(
                      icon: Icons.build,
                      label: 'Zadnji veliki servis',
                      value: DateFormat('dd.MM.yyyy')
                          .format(automobileAd.lastBigService!),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: Colors.blueGrey,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _infoTileWithIcon({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: iconColor,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.blueGrey,
          ),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
