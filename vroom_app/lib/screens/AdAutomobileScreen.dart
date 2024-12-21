import 'package:flutter/material.dart';
import 'package:vroom_app/components/LoginButton.dart';
import 'package:vroom_app/services/AuthService.dart';

class AddAutomobileScreen extends StatelessWidget {
  const AddAutomobileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getUsername(), // Provera korisnika
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Prikaz učitavanja
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // Korisnik nije prijavljen
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dodaj Oglas'),
              iconTheme: IconThemeData(
                color: Colors.blue, // Set the back icon color to blue
              ),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Morate se prijaviti da biste objavili oglas.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

        // Ako je korisnik prijavljen, prikazujemo ekran za dodavanje oglasa
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dodaj Oglas'),
            iconTheme: IconThemeData(
              color: Colors.blue, // Set the back icon color to blue
            ),
          ),
          body: const Center(
            child: Text(
              'Dodavanje automobila je trenutno dostupno.',
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
