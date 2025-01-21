import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';
import '../../models/automobileAd.dart';
import '../../services/FavoritesService.dart';
import '../../services/StripeService.dart';
import '../../utils/helpers.dart';

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
      ToastUtils.showErrorToast(message: "Greška prilikom provjere favorita.");
    }
  }

  Future<void> _addToFavorites() async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        ToastUtils.showErrorToast(message: "Niste prijavljeni.");

        return;
      }

      await _favoritesService.addFavorite(userId, widget.automobileAd.id);
      setState(() {
        _isFavorite = true;
        _favoritesService.fetchFavorites(); // osvežavanje
      });

      ToastUtils.showToast(message: 'Dodano u favorite.');
    } catch (e) {
      ToastUtils.showErrorToast(message: "Došlo je do greške.");
    }
  }

  Future<void> _removeFromFavorites() async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        ToastUtils.showErrorToast(message: "Niste prijavljeni.");

        return;
      }

      await _favoritesService.removeFavorite(userId, widget.automobileAd.id);
      setState(() {
        _isFavorite = false;
        _favoritesService.fetchFavorites();
      });

      ToastUtils.showToast(message: 'Uklonjeno iz favorita');
    } catch (e) {
      ToastUtils.showErrorToast(message: "Došlo je do greške.");
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

                            ToastUtils.showToast(message: "Plaćanje uspešno!");
                          } catch (e) {
                            ToastUtils.showErrorToast(
                                message: "'Greška prilikom plaćanja: $e");
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
      future: _getUserId(),
      builder: (context, snapshot) {
        final userId = snapshot.data;
        final isDone = widget.automobileAd.status == "Done";

        return Stack(
          children: [
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Favorite Icon Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Glavni naslov
                          Text(
                            widget.automobileAd.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),

                          if (widget.automobileAd.highlightExpiryDate != null &&
                              userId == widget.automobileAd.user?.id)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.rocket_launch,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                if (widget.automobileAd.highlightExpiryDate !=
                                        null &&
                                    userId == widget.automobileAd.user?.id)
                                  Text(
                                    FormatRemainingTime(widget
                                        .automobileAd.highlightExpiryDate!),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Ostatak tvog koda za "favorite" ikonu:
                    if (userId != null &&
                        widget.automobileAd.user != null &&
                        userId != widget.automobileAd.user?.id &&
                        !isDone) // Disable favorites for "Done" ads
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
                                ? Colors.red.shade50
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: _isFavorite
                                ? Border.all(color: Colors.red, width: 1.5)
                                : null,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.favorite,
                            color:
                                _isFavorite ? Colors.red : Colors.red.shade300,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                // Price and Highlight Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.indigo, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.indigo.shade50,
                      ),
                      child: Text(
                        '${NumberFormat('#,##0').format(widget.automobileAd.price)} KM',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (userId != null &&
                        widget.automobileAd.user != null &&
                        userId == widget.automobileAd.user?.id)
                      ElevatedButton.icon(
                        onPressed: isDone
                            ? null // Disable the button for "Done" ads
                            : _showHighlightModal,
                        icon: Icon(
                          isDone ? Icons.close : Icons.star_border,
                          size: 16,
                          color: isDone ? Colors.red : Colors.amber,
                        ),
                        label: Text(
                          isDone ? 'Završeno' : 'Izdvoji',
                          style: TextStyle(
                            color: isDone ? Colors.red : Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration:
                                isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor:
                              isDone ? Colors.red.shade50 : Colors.transparent,
                          side: BorderSide(
                            color: isDone ? Colors.red : Colors.grey,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
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
            ),

            // Red Overlay for "Done" ads
            if (isDone)
              Positioned.fill(
                child: Container(
                  color: Colors.red.withOpacity(0.2),
                  child: const Center(
                    child: Text(
                      'Oglas završen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
