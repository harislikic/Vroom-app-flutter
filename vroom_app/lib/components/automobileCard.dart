import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Dodajemo za formatiranje datuma
import '../models/automobileAd.dart';
import '../screens/automobileDetailsScreen.dart';

class AutomobileCard extends StatelessWidget {
  final AutomobileAd automobileAd;

  const AutomobileCard({Key? key, required this.automobileAd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatiramo datum u "dd.MM.yyyy" format
    String formattedDate =
        DateFormat('dd.MM.yyyy').format(automobileAd.dateOfAdd);

    // Provjera da li je automobil izdvojen na osnovu highlightExpiryDate
    bool isHighlighted = automobileAd.highlightExpiryDate != null &&
        automobileAd.highlightExpiryDate!.isAfter(DateTime.now());

    return GestureDetector(
      onTap: () {
        // Navigacija na novi ekran sa detaljima automobila
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AutomobileDetailsScreen(
              automobileAdId: automobileAd.id,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Zaobljene ivice
        ),
        elevation: 4, // Sjenka
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prikaz slike
            if (automobileAd.images.isNotEmpty)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.network(
                    'http://localhost:5194${automobileAd.images.first.imageUrl}',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Provjera da li je oglas izabran i dodavanje oznake
                  if (isHighlighted)
                    Positioned(
                      top: 4,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(
                              0.5), // Lagano žuta pozadina sa prozirnošću za blur efekt
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.amber, // Žuti border oko oznake
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.1), // Blagi shadow za efekt zamućenja
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Izdvojeno',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(
                                    0.8), // Blaga prozirnost da ne bude previše upadljivo
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Avatar korisnika
                  Positioned(
                    bottom: -15, // Avatar preklapa sadržaj ispod
                    right: 8, // Pomeranje desno
                    child: Stack(
                      alignment:
                          Alignment.center, // Centriramo avatar unutar okvira
                      children: [
                        // Bela pozadina oko avatara
                        Container(
                          width: 40, // Širina spoljnog kruga
                          height: 40, // Visina spoljnog kruga
                          decoration: const BoxDecoration(
                            color: Colors.white, // Bela boja za okvir
                            shape: BoxShape.circle, // Zaobljeni okvir
                          ),
                        ),
                        // Avatar korisnika
                        CircleAvatar(
                          radius: 18, // Veličina avatara
                          backgroundImage: NetworkImage(
                            'http://localhost:5194${automobileAd.user.profilePicture}',
                          ), // Slika korisnika
                          backgroundColor: Colors
                              .grey.shade300, // Rezervna boja ako nema slike
                        ),
                      ],
                    ),
                  ),
                  // View count ikonica u gornji lijevi ugao
                  Positioned(
                    bottom: -10,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.visibility,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${automobileAd.viewsCount}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                height: 140,
                color: Colors.grey.shade200,
                child: const Center(
                  child:
                      Icon(Icons.directions_car, size: 40, color: Colors.grey),
                ),
              ),
            // Sadržaj kartice
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Naslov oglasa
                  SizedBox(
                    height:
                        40, // Fiksna visina za naslov, osigurava konzistentnost
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        automobileAd.title,
                        style: const TextStyle(
                          fontSize: 14, // Veličina fonta
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2, // Maksimalno 2 reda
                        overflow: TextOverflow.ellipsis, // Dodaje ellipsis
                      ),
                    ),
                  ),

                  const SizedBox(height: 2), // Manji razmak
                  // Ikonice i tekstovi ispod njih
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white70, // Pozadinska boja
                      borderRadius: BorderRadius.circular(
                          10), // Zaobljeni uglovi od 10 piksela
                    ),
                    padding: const EdgeInsets.only(
                        top: 8, left: 8, right: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Ikonica i tekst za gorivo
                        Column(
                          children: [
                            const Icon(Icons.local_gas_station,
                                size: 20, color: Colors.grey),
                            const SizedBox(height: 2),
                            Text(
                              automobileAd.fuelType?.name ?? '-',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                            ),
                          ],
                        ),
                        // Ikonica i tekst za kilometražu
                        Column(
                          children: [
                            const Icon(Icons.speed,
                                size: 20, color: Colors.grey),
                            const SizedBox(height: 2),
                            Text(
                              '${automobileAd.mileage} km',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                            ),
                          ],
                        ),
                        // Ikonica i tekst za godinu proizvodnje
                        Column(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 20, color: Colors.grey),
                            const SizedBox(height: 2),
                            Text(
                              '${automobileAd.yearOfManufacture}',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4), // Manji razmak

                  // Cijena
                  Text(
                    '${automobileAd.price.toStringAsFixed(2)} KM',
                    style: const TextStyle(
                      fontSize: 14, // Smanjen font cene
                      fontWeight: FontWeight.bold,
                    ),
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
