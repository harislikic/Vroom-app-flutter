import 'package:flutter/material.dart';
import 'package:vroom_app/components/LoginButton.dart';
import 'package:vroom_app/services/AuthService.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getUsername(), // Provera korisničkog imena
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Prikaz učitavanja
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // Korisnik nije prijavljen
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Morate se prijaviti da biste vijdjeli svoje Favorite oglase.",
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
          );
        }

        // Ako je korisnik prijavljen, prikazujemo sadržaj
        return const Center(
          child: Text(
            "Vaši omiljeni oglasi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
