import 'package:flutter/material.dart';
import 'package:vroom_app/components/AnotherCarsFromUserCard.dart';
import 'package:vroom_app/models/automobileAd.dart';
import 'package:vroom_app/services/AutomobileAdService.dart';

class UserAdsCarousel extends StatefulWidget {
  final int currentAdId;
  final int userId;

  const UserAdsCarousel(
      {Key? key, required this.currentAdId, required this.userId})
      : super(key: key);

  @override
  _UserAdsCarouselState createState() => _UserAdsCarouselState();
}

class _UserAdsCarouselState extends State<UserAdsCarousel> {
  late Future<List<AutomobileAd>> _futureUserAds;
  final AutomobileAdService _automobileAdService = AutomobileAdService();

  @override
  void initState() {
    super.initState();
    _futureUserAds = _fetchUserAds();
  }

  Future<List<AutomobileAd>> _fetchUserAds() async {
    final userAds = await _automobileAdService.fetchUserAutomobiles(
      userId: widget.userId.toString(),
      page: 0,
      pageSize: 10,
    );
    return userAds.where((ad) => ad.id != widget.currentAdId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AutomobileAd>>(
      future: _futureUserAds,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final userAds = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Ostali oglasi korisnika",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userAds.length,
                  itemBuilder: (context, index) {
                    final ad = userAds[index];
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
          return const Center(child: Text('Korisnik nema drugih oglasa'));
        }
      },
    );
  }
}
