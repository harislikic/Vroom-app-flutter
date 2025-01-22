import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vroom_app/components/CarDetailsCards/CarDescriptionCard.dart';
import 'package:vroom_app/components/CommentSection.dart';
import 'package:vroom_app/components/RecommendedCarousel.dart';
import 'package:vroom_app/components/Reservation/ReservationCalendar.dart';
import 'package:vroom_app/models/reservation.dart';
import 'package:vroom_app/screens/EditAutomobileScreen.dart';
import 'package:vroom_app/services/AuthService.dart';
import 'package:vroom_app/services/ReservationService.dart';
import '../components/CarDetailsCards/AdditionalEquipmentCard.dart';
import '../components/UserAdsCarousel.dart';
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
  late Future<List<Reservation>> futureReservations;

  final AutomobileAdService automobileAdService = AutomobileAdService();

  bool _isLoggedIn = false;
  int? _loggedInUserId;

  Future<List<Reservation>> _fetchReservations() async {
    return await ReservationService()
        .getReservationsByAutomobileId(automobileAdId: widget.automobileAdId);
  }

  @override
  void initState() {
    super.initState();
    futureAutomobileAd =
        automobileAdService.getAutomobileById(widget.automobileAdId);
    futureReservations = _fetchReservations();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final userId = await AuthService.getUserId();
    setState(() {
      _isLoggedIn = userId != null;
      _loggedInUserId = userId;
    });
  }

  void _navigateToEditScreen(BuildContext context, AutomobileAd automobileAd) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAutomobileScreen(automobileAd: automobileAd),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<AutomobileAd>(
        future: futureAutomobileAd,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final automobileAd = snapshot.data!;
            final isDone = automobileAd.status == "Done";
              return FutureBuilder<List<Reservation>>(
              future: futureReservations,
              builder: (context, reservationSnapshot) {
                if (reservationSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (reservationSnapshot.hasError) {
                  return Center(
                      child: Text('Error: ${reservationSnapshot.error}'));
                } else if (reservationSnapshot.hasData) {
                  final reservations = reservationSnapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Image carousel
                      CarImageCarousel(images: automobileAd.images),
                      
                      // Back button
                      Positioned(
                        top: 44,
                        left: 16,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 4, sigmaY: 4), // Blur effect
                            child: Container(
                              color: Colors.black
                                  .withOpacity(0.4), // Semi-transparent
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Edit button
                      Positioned(
                        top: 44,
                        right: 16,
                        child: FutureBuilder<AutomobileAd>(
                          future: futureAutomobileAd,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && _isLoggedIn) {
                              final automobileAd = snapshot.data!;
                              if (_loggedInUserId == automobileAd.user?.id) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded corners
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 2, sigmaY: 4), // Blur effect
                                    child: Container(
                                      color: Colors.black.withOpacity(0.2),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:0, vertical: 0),
                                      child: TextButton.icon(
                                        onPressed: () =>
                                            _navigateToEditScreen(
                                                context, automobileAd),
                                        icon: const Icon(Icons.edit,
                                            color: Colors.white),
                                        label: const Text(
                                          'Uredi',
                                          style:
                                              TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        CarDescriptionCard(
                            description: automobileAd.description),
                        CarOwnerInfoCard(automobileAd: automobileAd),
                        const SizedBox(height: 16),
                        ReservationCalendar(
                           reservations: reservations,
                          automobileAdId: automobileAd.id,
                          automobileOwnerId: automobileAd.user!.id,
                        ),
                        const SizedBox(height: 32),
                        if (!isDone) CommentsSection(automobileAd.id),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: UserAdsCarousel(
                      currentAdId: automobileAd.id,
                      userId: automobileAd.user!.id,
                    ),
                  ),
                  if(_isLoggedIn)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: RecommendedCarousel(),
                  ),
                ],
              ),
                 );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
