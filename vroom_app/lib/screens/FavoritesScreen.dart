import 'package:flutter/material.dart';
import 'package:vroom_app/components/FavoritesAutomobileCard.dart';
import 'package:vroom_app/components/LoginButton.dart';
import 'package:vroom_app/models/favoritesAutomobiles.dart';
import 'package:vroom_app/services/FavoritesService.dart';
import 'package:vroom_app/services/AuthService.dart';

import 'package:vroom_app/main.dart' show routeObserver;

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with RouteAware {
  final FavoritesService _favoritesService = FavoritesService();
  late Future<List<FavoritesAutomobiles>> _favoriteAds;

  @override
  void initState() {
    super.initState();
    _favoriteAds = _favoritesService.fetchFavorites(); // Initial fetch
  }

  // Pomoćna metoda za refetch
  void _refreshFavorites() {
    setState(() {
      _favoriteAds = _favoritesService.fetchFavorites();
    });
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _refreshFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _removeFavorite(int favoriteId) async {
    final userId = await AuthService.getUserId();
    await _favoritesService.removeFavorite(userId!, favoriteId);
    _refreshFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Omiljeni Oglasi'),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.0),
                    child: Text(
                      "Morate se prijaviti da biste videli svoje Favorite oglase.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LoginButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Omiljeni Oglasi'),
            backgroundColor: Colors.blueGrey[900],
          ),
          body: FutureBuilder<List<FavoritesAutomobiles>>(
            future: _favoriteAds,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Center(
                  child: Text(
                    'Greška: ${snapshot.error?.toString() ?? 'Nepoznata greška'}',
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nemate omiljene oglase.'));
              }

              final ads = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 4 / 6,
                  ),
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    return FavoritesAutomobileCard(
                      favoritesAutomobile: ads[index],
                      onRemoveFavorite: _removeFavorite,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
