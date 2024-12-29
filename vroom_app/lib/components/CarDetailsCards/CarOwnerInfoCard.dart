import 'package:flutter/material.dart';
import '../../models/automobileAd.dart';

class CarOwnerInfoCard extends StatefulWidget {
  final AutomobileAd automobileAd;

  const CarOwnerInfoCard({Key? key, required this.automobileAd})
      : super(key: key);

  @override
  _CarOwnerInfoCardState createState() => _CarOwnerInfoCardState();
}

class _CarOwnerInfoCardState extends State<CarOwnerInfoCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded; // Prebacivanje stanja između otvorenog i zatvorenog
        });
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300), // Trajanje animacije
          curve: Curves.easeInOut, // Kriva animacije
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section to indicate owner profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Vlasnik',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up // Ikonica za sažimanje
                          : Icons.keyboard_arrow_down, // Ikonica za proširenje
                      color: Colors.black54,
                    ),
                  ],
                ),
                // Samo prikaži sadržaj ako je kartica proširena
                if (_isExpanded) ...[
                  const SizedBox(height: 12), // Razmak ispod naslova

                  // User Profile Row
                  Row(
                    children: [
                      // Avatar ili slika korisnika
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'http://localhost:5194${widget.automobileAd.user.profilePicture}',
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
                              '${widget.automobileAd.user.firstName} ${widget.automobileAd.user.lastName}',
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
                                  widget.automobileAd.user.phoneNumber ?? '',
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
                  const SizedBox(height: 16), // Razmak između sekcija

                  // City and Canton Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Grad vlasnika
                            Text(
                              'Grad: ${widget.automobileAd.user.city?.title}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Kanton vlasnika
                            Text(
                              'Kanton: ${widget.automobileAd.user.city?.canton.title}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
