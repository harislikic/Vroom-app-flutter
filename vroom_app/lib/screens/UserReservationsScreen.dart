import 'package:flutter/material.dart';
import 'package:vroom_app/components/ConfirmationDialog.dart';
import 'package:vroom_app/components/Reservation/ReservationCard.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';
import 'package:vroom_app/models/reservation.dart';
import 'package:vroom_app/services/ReservationService.dart';
import 'package:vroom_app/services/AuthService.dart';

class UserReservationsScreen extends StatefulWidget {
  const UserReservationsScreen({Key? key}) : super(key: key);

  @override
  _UserReservationsScreenState createState() => _UserReservationsScreenState();
}

class _UserReservationsScreenState extends State<UserReservationsScreen> {
  String selectedStatus = "Pending"; // Initial status for filtering
  List<Reservation> reservations = [];
  bool isLoading = true;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Morate biti prijavljeni.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final reservationService = ReservationService();
      final fetchedReservations = await reservationService.getUserReservations(
        userId: userId!,
        status: selectedStatus,
      );

      setState(() {
        reservations = fetchedReservations;
        currentPage = 1;
        hasMoreData = fetchedReservations.length == 25;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri dohvaćanju rezervacija: $e')),
      );
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
      final fetchedReservations = await reservationService.getUserReservations(
        userId: userId!,
        status: selectedStatus,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri dohvaćanju više rezervacija: $e')),
      );
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

  void _approveReservation(int reservationId) async {
    final reservationService = ReservationService();
    try {
      await reservationService.approveReservation(reservationId: reservationId);
      await _fetchReservations();
    } catch (e) {
      ToastUtils.showErrorToast(
          message: 'Greška pri odobravanju rezervacije: $e');
    }
  }

  void _rejectReservation(int reservationId) async {
    final reservationService = ReservationService();
    try {
      await reservationService.rejectReservation(reservationId: reservationId);
      await _fetchReservations();
    } catch (e) {
      ToastUtils.showErrorToast(
          message: 'Greška pri odbijanju rezervacije: $e');
    }
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
          Container(
            color: Colors.grey.shade900,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusButton("Pending", "Na čekanju"),
                _buildStatusButton("Approved", "Odobrene"),
                _buildStatusButton("Rejected", "Odbijene"),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                      return ReservationCard(
                        reservation: reservation,
                        onApprove: reservation.status == "Pending"
                            ? () {
                                _confirmAction(
                                  context: context,
                                  title: "Potvrda odobravanja",
                                  content:
                                      "Da li ste sigurni da želite odobriti ovu rezervaciju?",
                                  successMessage:
                                      "Rezervacija uspješno odobrena.",
                                  onConfirm: () => _approveReservation(
                                      reservation.reservationId),
                                );
                              }
                            : null,
                        onDecline: reservation.status == "Pending"
                            ? () {
                                _confirmAction(
                                  context: context,
                                  title: "Potvrda odbijanja",
                                  content:
                                      "Da li ste sigurni da želite odbiti ovu rezervaciju?",
                                  successMessage:
                                      "Rezervacija uspješno odbijena.",
                                  onConfirm: () => _rejectReservation(
                                      reservation.reservationId),
                                );
                              }
                            : null,
                        onDelete: reservation.status != "Pending"
                            ? () {
                                _confirmAction(
                                  context: context,
                                  title: "Potvrda brisanja",
                                  content:
                                      "Da li ste sigurni da želite obrisati ovu rezervaciju?",
                                  successMessage:
                                      "Rezervacija uspješno obrisana.",
                                  onConfirm: () => _deleteReservation(
                                      reservation.reservationId),
                                );
                              }
                            : null,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status, String label) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedStatus = status;
          });
          _fetchReservations();
        },
        style: TextButton.styleFrom(
          backgroundColor: selectedStatus == status
              ? Colors.teal.shade800
              : Colors.grey.shade700,
          foregroundColor: Colors.white,
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
