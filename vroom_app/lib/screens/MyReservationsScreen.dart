import 'package:flutter/material.dart';
import 'package:vroom_app/components/ConfirmationDialog.dart';
import 'package:vroom_app/components/Reservation/MyReservationsCard.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';
import 'package:vroom_app/models/myReservation.dart';

import 'package:vroom_app/services/ReservationService.dart';
import 'package:vroom_app/services/AuthService.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({Key? key}) : super(key: key);

  @override
  _MyReservationsScreenState createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  List<MyReservation> reservations = [];
  bool isLoading = true;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  int currentPage = 0;
  int? userId;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchReservations();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isFetchingMore &&
          hasMoreData) {
        _fetchMoreReservations();
      }
    });
  }

  Future<void> _loadUserIdAndFetchReservations() async {
    final id = await AuthService.getUserId();
    setState(() {
      userId = id;
    });
    await _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    if (userId == null) {
      ToastUtils.showToast(message: "Morate biti prijavljeni.");

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final reservationService = ReservationService();
      final fetchedReservations = await reservationService.getMyReservations(
        userId: userId!,
      );

      setState(() {
        reservations = fetchedReservations;
        currentPage = 1;
        hasMoreData = fetchedReservations.length == 25;
      });
    } catch (e) {
      ToastUtils.showErrorToast(
          message: "Greška pri dohvaćanju rezervacija: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreReservations() async {
    if (userId == null || isFetchingMore || !hasMoreData) return;

    setState(() {
      isFetchingMore = true;
    });

    try {
      final reservationService = ReservationService();
      final fetchedReservations = await reservationService.getMyReservations(
        userId: userId!,
        page: currentPage + 1,
      );

      if (fetchedReservations.isEmpty) {
        setState(() {
          hasMoreData = false;
        });
      } else {
        setState(() {
          reservations.addAll(fetchedReservations);
          currentPage++;
        });
      }
    } catch (e) {
      ToastUtils.showErrorToast(
          message: "Greška pri dohvaćanju rezervacija: $e");
    } finally {
      setState(() {
        isFetchingMore = false;
      });
    }
  }

  void _confirmAction({
    required BuildContext context,
    required String title,
    required String content,
    required String successMessage,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        content: content,
        successMessage: successMessage,
        onConfirm: onConfirm,
        onCancel: () {},
      ),
    );
  }

  void _deleteReservation(int reservationId) async {
    final reservationService = ReservationService();
    try {
      await reservationService.deleteReservation(reservationId: reservationId);
      await _fetchReservations();
    } catch (e) {
      ToastUtils.showErrorToast(message: 'Greška pri brisanju rezervacije: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moje rezervacije"),
        backgroundColor: Colors.teal.shade800,
        iconTheme: const IconThemeData(
          color: Colors.blueAccent,
        ),
      ),
      body: Column(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: reservations.length + 1,
                    itemBuilder: (context, index) {
                      if (reservations.isEmpty) {
                        return const Center(
                          child: Text("Nema dostupnih rezervacija."),
                        );
                      } else if (index == reservations.length) {
                        // Provera za kraj liste
                        return hasMoreData
                            ? const Center(
                                child:
                                    CircularProgressIndicator()) // Još učitavanja
                            : const SizedBox
                                .shrink(); // Ne prikazuj ništa kad nema više stranica
                      }

                      final reservation = reservations[index];
                      return MyReservationCard(
                        reservation: reservation,
                        onDelete: () {
                          if (reservation.status == "Pending") {
                            ToastUtils.showErrorToast(
                                message:
                                    "Rezervaciju možete otkazati tek kada bude odobrena.");
                          } else {
                            _confirmAction(
                              context: context,
                              title: "Potvrda brisanja",
                              content:
                                  "Da li ste sigurni da želite obrisati ovu rezervaciju?",
                              successMessage: "Rezervacija uspešno obrisana.",
                              onConfirm: () =>
                                  _deleteReservation(reservation.id),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
