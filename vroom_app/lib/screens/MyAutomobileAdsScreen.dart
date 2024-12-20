import 'package:flutter/material.dart';
import 'package:vroom_app/components/LoginButton.dart';
import 'package:vroom_app/services/AuthService.dart';

class MyAutomobileAdsScreen extends StatelessWidget {
  const MyAutomobileAdsScreen({Key? key}) : super(key: key);

  Future<bool> _checkIfLoggedIn() async {
    final userId = await AuthService.getUserId();
    return userId != null; // Provera da li postoji sačuvan ID korisnika
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moji Oglasi"),
      ),
      body: FutureBuilder<bool>(
        future: _checkIfLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), // Prikaz tokom čekanja na proveru
            );
          }

          if (snapshot.hasData && !snapshot.data!) {
            // Ako korisnik NIJE prijavljen
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Morate se prijaviti da biste vidjeli svoje oglase.",
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

          // Ako je korisnik prijavljen
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.car_rental,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  "Trenutno nemate oglasa.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
