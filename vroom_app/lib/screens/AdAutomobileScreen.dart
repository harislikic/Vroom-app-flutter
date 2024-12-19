import 'package:flutter/material.dart';

class AddAutomobileScreen extends StatelessWidget {
  const AddAutomobileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Oglas'),
      ),
      body: const Center(
        child: Text('Dodavanje automobila je trenutno dostupno.'),
      ),
    );
  }
}