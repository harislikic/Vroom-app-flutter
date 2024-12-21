import 'package:flutter/material.dart';
import 'package:vroom_app/components/FavoritesAutomobileCard.dart'; // Import the new FavoritesAutomobileCard
import 'package:vroom_app/components/LoginButton.dart';
import 'package:vroom_app/models/favoritesAutomobiles.dart'; // Import the model for FavoritesAutomobiles
import 'package:vroom_app/services/FavoritesService.dart'; // Import the FavoritesService
import 'package:vroom_app/services/AuthService.dart'; // Import AuthService

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  late Future<List<FavoritesAutomobiles>> _favoriteAds;

  @override
  void initState() {
    super.initState();
    _favoriteAds = _favoritesService.fetchFavorites(); // Fetch favorites
  }

  // Function to remove favorite
  void _removeFavorite(int favoriteId) async {
    final userId = await AuthService.getUserId();
    await _favoritesService.removeFavorite(userId!, favoriteId);

    setState(() {
      // Refresh the favorites list after removing the favorite
      _favoriteAds = _favoritesService.fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getUsername(), // Check if the user is logged in
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Loading indicator
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // User is not logged in
          return Scaffold(
            appBar: AppBar(
              title: const Text('Omiljeni Oglasi'),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Morate se prijaviti da biste videli svoje Favorite oglase.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
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

        // If user is logged in, display the content
        return Scaffold(
          appBar: AppBar(
            title: const Text('Omiljeni Oglasi'),
            backgroundColor: Colors.blueGrey[900],
          ),
          body: FutureBuilder<List<FavoritesAutomobiles>>(
            future: _favoriteAds,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(
                    'Error: ${snapshot.error}'); // Print the error for debugging purposes
                return Center(
                    child: Text(
                        'Greška: ${snapshot.error?.toString() ?? 'Nepoznata greška'}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Greška: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nemate omiljene oglase.'));
              } else {
                final ads = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Display 2 cards per row
                      crossAxisSpacing: 10, // Horizontal spacing
                      mainAxisSpacing: 10, // Vertical spacing
                      childAspectRatio: 4 / 6, // Aspect ratio for cards
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
              }
            },
          ),
        );
      },
    );
  }
}
