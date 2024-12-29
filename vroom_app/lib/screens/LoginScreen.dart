import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Dodaj Fluttertoast import
import 'package:vroom_app/services/AuthService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false; // State za prikaz lozinke

  void handleLogin() async {
    String username = usernameController.text.trim();
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Molimo vas da unesete korisničko ime i lozinku.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      return;
    }

    final success = await AuthService.login(username, password);
    if (success) {
      Navigator.pushReplacementNamed(context, '/'); // Navigacija na Home ekran
    } else {
      Fluttertoast.showToast(
        msg: "Korisničko ime ili email nisu ispravni.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  void handleRegister() {
    Navigator.pushNamed(
        context, '/register'); // Navigacija na ekran za registraciju
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.directions_car, size: 40, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Vroom",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Korisničko ime",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: !_isPasswordVisible, // Kontrola prikaza lozinke
                decoration: InputDecoration(
                  labelText: "Lozinka",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible =
                            !_isPasswordVisible; // Menjanje stanja
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900], // Pozadina tamno plava
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                        color: Colors.blue, width: 2), // Plavi border
                  ),
                ),
                child: const Text(
                  "Prijavi se",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Beli tekst
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: handleRegister,
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text.rich(
                  TextSpan(
                    text: "Nemate profil? ", // Tekst koji ostaje isti
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70, // Bele nijanse za "Nemate profil?"
                    ),
                    children: [
                      TextSpan(
                        text: "Registrujte se", // Tekst koji postaje plav
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue, // Plava boja za "Registrujte se"
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
