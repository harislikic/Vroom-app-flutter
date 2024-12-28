import 'package:flutter/material.dart';
import '../../models/automobileAd.dart';
import 'package:intl/intl.dart';

class CarAdditionalInfoCard extends StatefulWidget {
  final AutomobileAd automobileAd;

  const CarAdditionalInfoCard({Key? key, required this.automobileAd})
      : super(key: key);

  @override
  _CarAdditionalInfoCardState createState() => _CarAdditionalInfoCardState();
}

class _CarAdditionalInfoCardState extends State<CarAdditionalInfoCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd.MM.yyyy').format(widget.automobileAd.dateOfAdd);

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
            // Title Row with Expand Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dodatne informacije o vozilu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 28,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.blueGrey,
              thickness: 1.0,
              height: 20,
            ),

            // Main Content Section with Animation
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Column(
                      children: [
                        // Datum i Pregledi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _iconWithText(
                              icon: Icons.calendar_today,
                              label: 'Datum dodavanja',
                              value: formattedDate,
                            ),
                            _iconWithText(
                              icon: Icons.visibility,
                              label: 'Pregledi',
                              value: '${widget.automobileAd.viewsCount}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Registrovan i Stanje
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _iconWithText(
                              icon: Icons.car_repair,
                              label: 'Registrovan',
                              value: widget.automobileAd.registered ? 'Da' : 'Ne',
                              iconColor: widget.automobileAd.registered
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            _iconWithText(
                              icon: Icons.car_rental,
                              label: 'Stanje',
                              value: widget.automobileAd.vehicleCondition?.name ??
                                  '-',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Ostale Informacije
                        if (widget.automobileAd.registrationExpirationDate !=
                                null ||
                            widget.automobileAd.lastSmallService != null ||
                            widget.automobileAd.lastBigService != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.automobileAd.registrationExpirationDate !=
                                  null)
                                _infoRow(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Registracija ističe',
                                  value: DateFormat('dd.MM.yyyy').format(widget
                                      .automobileAd.registrationExpirationDate!),
                                ),
                              if (widget.automobileAd.lastSmallService != null)
                                _infoRow(
                                  icon: Icons.build_circle_outlined,
                                  label: 'Zadnji mali servis',
                                  value: DateFormat('dd.MM.yyyy').format(
                                      widget.automobileAd.lastSmallService!),
                                ),
                              if (widget.automobileAd.lastBigService != null)
                                _infoRow(
                                  icon: Icons.build,
                                  label: 'Zadnji veliki servis',
                                  value: DateFormat('dd.MM.yyyy').format(
                                      widget.automobileAd.lastBigService!),
                                ),
                            ],
                          ),
                      ],
                    )
                  : const SizedBox.shrink(), // Kad je zatvoreno, zauzima minimalni prostor
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconWithText({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = Colors.blueGrey,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: iconColor,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
            size: 24,
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
