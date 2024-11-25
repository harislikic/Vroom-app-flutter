import 'package:flutter/material.dart';
import '../models/automobile_ad.dart';
import '../services/api_service.dart';
import '../components/automobile_card.dart';

class AutomobileListScreen extends StatefulWidget {
  const AutomobileListScreen({Key? key}) : super(key: key);

  @override
  _AutomobileListScreenState createState() => _AutomobileListScreenState();
}

class _AutomobileListScreenState extends State<AutomobileListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<AutomobileAd>> _automobileAds;

  @override
  void initState() {
    super.initState();
    _automobileAds = _apiService.fetchAutomobileAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oglasi Automobila'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<AutomobileAd>>(
        future: _automobileAds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Greška: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nema dostupnih oglasa.'));
          } else {
            final ads = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Prikazuje 2 kartice u redu
                  crossAxisSpacing: 10, // Horizontalni razmak
                  mainAxisSpacing: 10, // Vertikalni razmak
              childAspectRatio: 4 / 6, // Odnos širine i visine kartica
                ),
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  return AutomobileCard(automobileAd: ads[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
