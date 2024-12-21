import 'package:flutter/material.dart';
import '../../models/automobileAd.dart';

class CarOwnerInfoCard extends StatelessWidget {
  final AutomobileAd automobileAd;

  const CarOwnerInfoCard({Key? key, required this.automobileAd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to user profile
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section to indicate owner profile
              const Text(
                'Vlasnik',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12), // Razmak ispod naslova
              
              // User Profile Row
              Row(
                children: [
                  // Avatar ili slika korisnika
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'http://localhost:5194${automobileAd.user.profilePicture}',
                    ), // Slika korisnika
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 16), // Razmak između slike i teksta

                  // Informacije o korisniku
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ime i prezime korisnika
                        Text(
                          '${automobileAd.user.firstName} ${automobileAd.user.lastName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8), // Manji razmak ispod imena

                        // Kontaktni broj
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              automobileAd.user.phoneNumber,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4), // Mali razmak

                        // Oznaka da je ovo kontakt vlasnika
                        const Text(
                          'Kontakt broj',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
