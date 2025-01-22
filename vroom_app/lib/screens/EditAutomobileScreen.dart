import 'package:flutter/material.dart';
import 'package:vroom_app/models/automobileAd.dart';

class EditAutomobileScreen extends StatelessWidget {
  final AutomobileAd automobileAd;

  const EditAutomobileScreen({Key? key, required this.automobileAd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uredi oglas'),
         iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
      ),
      body: const Center(
        child: Text('Editovanje oglasa'),
      ),
    );
  }
}
