import 'package:flutter/material.dart';
import '../../models/automobileAdEquipment.dart';

class CarAdditionalEquipmentCard extends StatefulWidget {
  final List<AutomobileAdEquipment> automobileAdEquipments;

  const CarAdditionalEquipmentCard({
    Key? key,
    required this.automobileAdEquipments,
  }) : super(key: key);

  @override
  _CarAdditionalEquipmentCardState createState() =>
      _CarAdditionalEquipmentCardState();
}

class _CarAdditionalEquipmentCardState
    extends State<CarAdditionalEquipmentCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.automobileAdEquipments.isEmpty) {
      return const SizedBox();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          // Naslovna traka sa dugmetom za otvaranje/zatvaranje
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: const Text(
              'Dodatna oprema:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Crna boja za naslov
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey[700],
                size: 28,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),

          // Animacija otvaranja/zatvaranja
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Wrap(
                spacing: 12.0, // Horizontalni razmak
                runSpacing: 12.0, // Vertikalni razmak kada prelazi u novi red
                children: widget.automobileAdEquipments.map((equipment) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          equipment.equipment.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
