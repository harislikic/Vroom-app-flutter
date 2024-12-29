import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/automobileAd.dart';
import '../../services/FavoritesService.dart';

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

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

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
        // Refetch favorites to update the state
        _favoritesService.fetchFavorites();
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
        // Refetch favorites to update the state
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                // Re-check after action
                await _checkIfFavorite();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _isFavorite
                      ? Colors.blue.shade50 // Background for favorite
                      : Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: _isFavorite
                      ? Border.all(color: Colors.blue, width: 1.5)
                      : null, // Blue border for favorite
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
        Text(
          '${NumberFormat('#,##0').format(widget.automobileAd.price)} KM',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
