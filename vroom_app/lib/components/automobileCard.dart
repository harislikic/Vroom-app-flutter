import 'package:flutter/material.dart';
import '../models/automobileAd.dart';
import '../screens/automobileDetailsScreen.dart';

class AutomobileCard extends StatelessWidget {
  final AutomobileAd automobileAd;
  final bool isGridView;

  const AutomobileCard(
      {Key? key, required this.automobileAd, required this.isGridView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        // Dodajemo glow efekat oko kartice ako je označen kao "highlighted"
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isHighlighted ? Colors.amber : Colors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Slika – Različita veličina zavisno od prikaza
              if (automobileAd.images.isNotEmpty)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.network(
                      'http://localhost:5194${automobileAd.images.first.imageUrl}',
                      height: isGridView ? 140 : 200, // Duža slika u ListView
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
                            color: Colors.amber.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.amber,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
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
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // View count ikonica u gornji lijevi ugao
                    Positioned(
                      bottom: -8,
                      right: 8,
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
                  height: isGridView
                      ? 140
                      : 200, // Različita visina kada je ListView
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.directions_car,
                        size: 40, color: Colors.grey),
                  ),
                ),
              // Sadržaj kartice
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Naslov oglasa – Veći font u ListView
                    SizedBox(
                      height: isGridView ? 40 : 60, // Različita visina naslova
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          automobileAd.title,
                          style: TextStyle(
                            fontSize:
                                isGridView ? 14 : 18, // Veći font u ListView
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Ikonice i tekstovi ispod njih
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.local_gas_station,
                                  size: isGridView ? 20 : 24,
                                  color: Colors.grey),
                              const SizedBox(height: 2),
                              Text(
                                automobileAd.fuelType?.name ?? '-',
                                style: TextStyle(
                                    fontSize: isGridView ? 10 : 12,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.speed,
                                  size: isGridView ? 20 : 24,
                                  color: Colors.grey),
                              const SizedBox(height: 2),
                              Text(
                                '${automobileAd.mileage} km',
                                style: TextStyle(
                                    fontSize: isGridView ? 10 : 12,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          if (!isGridView)
                            Column(
                              children: [
                                Icon(Icons.branding_watermark_outlined,
                                    size: isGridView ? 20 : 24,
                                    color: Colors.grey),
                                const SizedBox(height: 2),
                                Text(
                                  '${automobileAd.carBrand?.name}',
                                  style: TextStyle(
                                      fontSize: isGridView ? 10 : 12,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          Column(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: isGridView ? 20 : 24,
                                  color: Colors.grey),
                              const SizedBox(height: 2),
                              Text(
                                '${automobileAd.yearOfManufacture}',
                                style: TextStyle(
                                    fontSize: isGridView ? 10 : 12,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Cijena
                    Text(
                      '${automobileAd.price.toStringAsFixed(2)} KM',
                      style: TextStyle(
                        fontSize: isGridView ? 14 : 18, // Veći font u ListView
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
