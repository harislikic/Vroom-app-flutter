import 'package:flutter/material.dart';

class CarDescriptionCard extends StatelessWidget {
  final String description;

  const CarDescriptionCard({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.blue[50], // Svetloplava pozadina
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.description,
              color: Colors.blue,
            ),
            SizedBox(width: 8),
            Text(
              'Detaljan opis:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  ),
)
;
  }
}
