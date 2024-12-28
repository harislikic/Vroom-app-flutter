import 'package:flutter/material.dart';
import 'package:vroom_app/components/CarDetailsCards/CarDescriptionCard.dart';
import '../components/CarDetailsCards/AdditionalEquipmentCard.dart';
import '../models/automobileAd.dart';
import '../services/AutomobileAdService.dart';
import '../components/CarDetailsCards/CarDetailsCard.dart';
import '../components/CarDetailsCards/CarSpecificationsCard.dart';
import '../components/CarDetailsCards/CarAdditionalInfoCard.dart';
import '../components/CarDetailsCards/CarOwnerInfoCard.dart';
import '../components/CarDetailsCards/CarImageCarousel.dart';

class AutomobileDetailsScreen extends StatefulWidget {
  final int automobileAdId;

  const AutomobileDetailsScreen({Key? key, required this.automobileAdId})
      : super(key: key);

  @override
  _AutomobileDetailsScreenState createState() =>
      _AutomobileDetailsScreenState();
}

class _AutomobileDetailsScreenState extends State<AutomobileDetailsScreen> {
  late Future<AutomobileAd> futureAutomobileAd;
  final AutomobileAdService automobileAdService = AutomobileAdService();

  @override
  void initState() {
    super.initState();
    futureAutomobileAd =
        automobileAdService.getAutomobileById(widget.automobileAdId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automobile Details'),
        iconTheme: IconThemeData(
          color: Colors.blue, // Set the back icon color to blue
        ),
      ),
      body: FutureBuilder<AutomobileAd>(
        future: futureAutomobileAd,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final automobileAd = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CarImageCarousel without padding
                  CarImageCarousel(images: automobileAd.images),
                  
                  // Rest of the content with padding
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        CarDetailsCard(automobileAd: automobileAd),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: CarSpecificationsCard(
                              automobileAd: automobileAd),
                        ),
                        CarAdditionalInfoCard(automobileAd: automobileAd),
                        CarAdditionalEquipmentCard(
                            automobileAdEquipments:
                                automobileAd.automobileAdEquipments),
                        CarDescriptionCard(description: automobileAd.description),
                        CarOwnerInfoCard(automobileAd: automobileAd),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
