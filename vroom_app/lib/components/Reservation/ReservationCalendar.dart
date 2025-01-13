import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vroom_app/components/Reservation/ReservationCalendarView.dart';
import 'package:vroom_app/components/Reservation/ReservationModal.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';
import 'package:vroom_app/models/reservation.dart';
import 'package:vroom_app/services/AuthService.dart';
import 'package:vroom_app/services/ReservationService.dart';

class ReservationCalendar extends StatefulWidget {
  final List<Reservation> reservations;
  final int automobileAdId;

  const ReservationCalendar({
    Key? key,
    required this.reservations,
    required this.automobileAdId,
  }) : super(key: key);

  @override
  _ReservationCalendarState createState() => _ReservationCalendarState();
}

class _ReservationCalendarState extends State<ReservationCalendar> {
  DateTime _selectedDay = DateTime.now();
  late List<Reservation> _currentReservations;

  @override
  void initState() {
    super.initState();
    _currentReservations = widget.reservations;
  }

  void _showReservationModal(BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ReservationModal(
          selectedDay: selectedDay,
          onConfirm: (reservationDateTime) {
            _sendReservationRequest(reservationDateTime);
          },
        );
      },
    );
  }

  Future<void> _sendReservationRequest(DateTime reservationDateTime) async {
    try {
      final reservationService = ReservationService();
      final userId = await AuthService.getUserId();

      await reservationService.createReservation(
        reservationDate: reservationDateTime,
        userId: userId!,
        automobileAdId: widget.automobileAdId,
      );

      ToastUtils.showToast(message: 'Rezervacija uspješno dodana.');
      final updatedReservations = await reservationService
          .getReservationsByAutomobileId(automobileAdId: widget.automobileAdId);

      setState(() {
        _currentReservations = updatedReservations;
      });
    } catch (e) {
      ToastUtils.showErrorToast(
        message: 'Greška pri dodavanju rezervacije: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Reservation>> reservationsByDate = {};
    for (var reservation in _currentReservations) {
      final String dateKey = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(reservation.reservationDate));
      if (!reservationsByDate.containsKey(dateKey)) {
        reservationsByDate[dateKey] = [];
      }
      reservationsByDate[dateKey]!.add(reservation);
    }

    return Column(
      children: [
        ReservationCalendarView(
          reservationsByDate: reservationsByDate,
          selectedDay: _selectedDay,
          onDaySelected: (selectedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });

            final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);

            if (reservationsByDate.containsKey(formattedDate)) {
              final reservations = reservationsByDate[formattedDate]!;
              final hasApproved =
                  reservations.any((res) => res.status == "Approved");
              final hasPending =
                  reservations.any((res) => res.status == "Pending");

              if (hasApproved) {
                ToastUtils.showErrorToast(
                    message: 'Datum je odobren i zauzet.');
              } else if (hasPending) {
                ToastUtils.showInfoToast(message: 'Datum je u obradi.');
              }
            } else {
              _showReservationModal(context, selectedDay);
            }
          },
        ),
      ],
    );
  }
}
