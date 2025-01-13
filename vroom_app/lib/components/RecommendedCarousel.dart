import 'package:flutter/material.dart';
import 'package:vroom_app/components/AnotherCarsFromUserCard.dart';
import 'package:vroom_app/models/automobileAd.dart';
import 'package:vroom_app/services/AutomobileAdService.dart';

class RecommendedCarousel extends StatefulWidget {
  const RecommendedCarousel({Key? key}) : super(key: key);

  @override
  _RecommendedCarouselState createState() => _RecommendedCarouselState();
}

class _RecommendedCarouselState extends State<RecommendedCarousel> {
  late Future<List<AutomobileAd>> _futureRecommendedAds;
  final AutomobileAdService _automobileAdService = AutomobileAdService();

  @override
  void initState() {
    super.initState();
   _futureRecommendedAds = _fetchRecommendedAds();
  }

  Future<List<AutomobileAd>> _fetchRecommendedAds() async {
    final recommendedAds =
        await _automobileAdService.fetchRecommendAutomobiles();
    return recommendedAds;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AutomobileAd>>(
      future: _futureRecommendedAds,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final recommendedAds = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.recommend, // Ikona za "Preporučeni oglasi"
                      color: Colors.grey, // Tamnija siva boja
                      size: 24, // Veličina ikone
                    ),
                    const SizedBox(width: 8), // Razmak između ikone i teksta
                    Text(
                      "Preporučeni oglasi",
                      style: TextStyle(
                        fontSize: 18, // Malo veći font
                        fontWeight: FontWeight.w600, // Polu-deblji font
                        color: Colors.black87, // Tamnija siva boja
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedAds.length,
                  itemBuilder: (context, index) {
                    final ad = recommendedAds[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 180,
                        height: 120,
                        child: AnotherCarsFromUserCard(
                          automobileAd: ad,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Nema preporučenih oglasa'));
        }
      },
    );
  }
}
