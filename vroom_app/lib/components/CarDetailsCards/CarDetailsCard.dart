import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/automobileAd.dart';
import '../../services/FavoritesService.dart';
import '../../services/StripeService.dart';

class CarDetailsCard extends StatefulWidget {
  final AutomobileAd automobileAd;

  const CarDetailsCard({Key? key, required this.automobileAd})
      : super(key: key);

  @override
  _CarDetailsCardState createState() => _CarDetailsCardState();
}

class _CarDetailsCardState extends State<CarDetailsCard> {
  bool _isFavorite = false;
  final FavoritesService _favoritesService = FavoritesService();
  final StripeService _stripeService = StripeService();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  // ---------------- FAVORITES LOGIKA ----------------
  Future<void> _checkIfFavorite() async {
    try {
      final userId = await _getUserId();
      if (userId == null) return;

      final favorites = await _favoritesService.fetchFavorites();
      setState(() {
        _isFavorite = favorites.any((fav) => fav.id == widget.automobileAd.id);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Greška prilikom provjere favorita.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _addToFavorites() async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        Fluttertoast.showToast(
          msg: 'Niste prijavljeni.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      await _favoritesService.addFavorite(userId, widget.automobileAd.id);
      setState(() {
        _isFavorite = true;
        _favoritesService.fetchFavorites(); // osvežavanje
      });

      Fluttertoast.showToast(
        msg: 'Dodano u favorite.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Došlo je do greške.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _removeFromFavorites() async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        Fluttertoast.showToast(
          msg: 'Niste prijavljeni.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      await _favoritesService.removeFavorite(userId, widget.automobileAd.id);
      setState(() {
        _isFavorite = false;
        _favoritesService.fetchFavorites();
      });

      Fluttertoast.showToast(
        msg: 'Uklonjeno iz favorita.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Došlo je do greške.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  static Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // ---------------- STRIPE LOGIKA ----------------

  void _showHighlightModal() {
    int highlightDays = 1;
    double amount = 3.0;

    Map<int, double> prices = {
      1: 3.0,
      3: 5.0,
      7: 8.0,
      30: 15.0,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Ovde dodajemo shape i backgroundColor
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Colors.grey, // sivi border
          width: 2,
        ),
      ),
      backgroundColor: Colors.white, // bela pozadina
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              // Povećavamo visinu modala:
              child: Container(
                // Minimalna visina (npr. polovinu ekrana)
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Izdvoji oglas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // crni tekst
                      ),
                    ),
                    const SizedBox(height: 20),

                    // BROJ DANA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Broj dana:',
                          style: TextStyle(color: Colors.black),
                        ),
                        DropdownButton<int>(
                          value: highlightDays,
                          items: prices.keys.map((days) {
                            return DropdownMenuItem(
                              value: days,
                              child: Text(
                                '$days dana',
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setModalState(() {
                              highlightDays = value ?? 1;
                              amount = prices[highlightDays]!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // UKUPNA CIJENA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ukupna cijena:',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          '$amount USD',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Dugme na sredini
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context); // Zatvori modal

                          try {
                            await _stripeService.makePayment(
                              amount: amount,
                              highlightDays: highlightDays,
                              automobileAdId: widget.automobileAd.id,
                            );

                            Fluttertoast.showToast(
                              msg: 'Plaćanje uspešno!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: 'Greška prilikom plaćanja: $e',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.payment, // ikonica za plaćanje
                          color: Colors.black,
                        ),
                        label: const Text(
                          'Plati',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // transparent
                          elevation: 0,
                          side: const BorderSide(color: Colors.grey, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      // Dohvatimo userId asinhrono
      future: _getUserId(),
      builder: (context, snapshot) {
        final userId = snapshot.data; // Trenutno logovani korisnik ID

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRVI RED - Naziv i ikonica za favorite
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.automobileAd.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    if (_isFavorite) {
                      await _removeFromFavorites();
                    } else {
                      await _addToFavorites();
                    }
                    await _checkIfFavorite();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isFavorite
                          ? Colors.blue.shade50
                          : Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: _isFavorite
                          ? Border.all(color: Colors.blue, width: 1.5)
                          : null,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.favorite,
                      color: _isFavorite ? Colors.blue : Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // PRIKAZ CIJENE i (eventualno) DUGME "Izdvoji" U ISTOM REDU
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${NumberFormat('#,##0').format(widget.automobileAd.price)} KM',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                // Prikaži dugme samo ako je userId == user oglasa
                // Pretpostavka: widget.automobileAd.user.id je ID vlasnika
                if (userId != null &&
                    widget.automobileAd.user != null &&
                    userId == widget.automobileAd.user.id)
                    
                  ElevatedButton.icon(
                    onPressed: _showHighlightModal,
                    icon: const Icon(Icons.star_border, size: 16),
                    label: const Text(
                      'Izdvoji',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      // Siva bordura
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0, // ravan izgled
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
