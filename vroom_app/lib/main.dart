import 'package:flutter/material.dart';

import 'screens/ automobile_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Uklanja debug baner
      title: 'Automobili Oglasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AutomobileListScreen(), // Postavljamo početni ekran
    );
  }
}
