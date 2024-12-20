import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.blueGrey[900], // Tamno plava pozadina
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.blue, width: 2), // Plavi okvir
        ),
      ),
      child: const Text(
        "Prijavi se",
        style: TextStyle(
          color: Colors.white, // Crna boja teksta
          fontSize: 16,
        ),
      ),
    );
  }
}
