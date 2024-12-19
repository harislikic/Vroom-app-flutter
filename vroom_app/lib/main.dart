import 'package:flutter/material.dart';
import 'package:vroom_app/screens/%20automobileListScreen.dart';

import 'package:vroom_app/screens/AdAutomobileScreen.dart';
import 'package:vroom_app/screens/FavoritesScreen.dart';
import 'package:vroom_app/screens/ProfileScreen.dart';
import 'components/CustomNavigationBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Automobili Oglasi',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900], // Koristi nullable boju
          elevation: 2, // Smanjena visina zaglavlja
          toolbarHeight: 50, // Visina zaglavlja
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/favorites': (context) => const MainScreen(initialIndex: 1),
        '/profile': (context) => const MainScreen(initialIndex: 3),
        '/add-ad': (context) => const AddAutomobileScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const AutomobileListScreen(),
    const FavoritesScreen(),
    const Center(
        child: Text('Dodavanje oglasa placeholder')), // Placeholder za AddAd
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomNavigationBarWithButton(
        currentIndex: _currentIndex,
        onTap: _onItemSelected,
        onAddPressed: () {
          Navigator.pushNamed(context, '/add-ad');
        },
      ),
    );
  }
}
