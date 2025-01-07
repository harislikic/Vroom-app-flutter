import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/automobileAd.dart';
import '../screens/automobileDetailsScreen.dart';

class MyAutomobileAdsCard extends StatelessWidget {
  final AutomobileAd automobileAd;
  final Future<void> Function(int automobileId) onRemove;

  const MyAutomobileAdsCard({
    Key? key,
    required this.automobileAd,
    required this.onRemove,
  }) : super(key: key);

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Potvrda brisanja"),
          content:
              const Text("Da li ste sigurni da želite da uklonite ovaj oglas?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Otkaži"),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop(); // Zatvara dijalog
                await onRemove(automobileAd.id); // Poziva funkciju za brisanje
              },
              label: const Text(
                "Potvrdi",
                style: TextStyle(
                  color: Colors.black, // Crni tekst
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(
                Icons.delete_outline_outlined, // Ikona za brisanje
                color: Colors.red, // Crvena boja ikone
                size: 20,
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor:
                    Colors.white, // Boja teksta i ikone pri interakciji
                side: const BorderSide(
                  color: Colors.blueGrey, // Boja okvira
                  width: 2, // Debljina okvira
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Zaobljeni uglovi
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, // Horizontalno unutrašnje rastojanje
                  vertical: 12.0, // Vertikalno unutrašnje rastojanje
                ),
                elevation: 2, // Lagano izdizanje dugmeta
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Velika slika na vrhu
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: automobileAd.images.isNotEmpty
                ? Image.network(
                    'http://localhost:5194${automobileAd.images.first.imageUrl}',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.directions_car,
                          size: 40, color: Colors.grey),
                    ),
                  ),
          ),

          // Naslov, datum i cena
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Naslov sa ikonom
                Row(
                  children: [
                    const Icon(
                      Icons.title,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        automobileAd.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Tanka linija ispod naslova
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                ),

                // Datum sa ikonom
                Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Datum dodavanja: ${DateFormat('dd.MM.yyyy').format(automobileAd.dateOfAdd)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                // Tanka linija ispod datuma
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                ),

                // Cena sa ikonom
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 18,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${NumberFormat('#,##0').format(automobileAd.price)} KM',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Ikone za brisanje i navigaciju
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ikona za brisanje
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                    size: 28,
                  ),
                  onPressed: () => _showConfirmationDialog(context),
                ),
                // Dugme "Poseti oglas"
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AutomobileDetailsScreen(
                          automobileAdId: automobileAd.id,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.directions_car, // Nova ikona
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Posjti oglas",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Boja teksta i ikone
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8, // Dodaje "shadow" efekat
                    shadowColor: Colors.blueAccent, // Boja senke
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
