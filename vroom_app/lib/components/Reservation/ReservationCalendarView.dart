import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vroom_app/models/reservation.dart';

class ReservationCalendarView extends StatelessWidget {
  final Map<String, List<Reservation>> reservationsByDate;
  final DateTime selectedDay;
  final void Function(DateTime selectedDay) onDaySelected;

  const ReservationCalendarView({
    Key? key,
    required this.reservationsByDate,
    required this.selectedDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();

    return TableCalendar(
      focusedDay: selectedDay,
      firstDay: today.subtract(const Duration(days: 30)),
      lastDay: today.add(const Duration(days: 365)),
      calendarStyle: CalendarStyle(
        defaultDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.withOpacity(0.1),
        ),
        todayDecoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        outsideDecoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.withOpacity(0.1),
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final formattedDate = DateFormat('yyyy-MM-dd').format(day);
          final isPastDate = day.isBefore(today);

          if (reservationsByDate.containsKey(formattedDate)) {
            final reservations = reservationsByDate[formattedDate]!;
            final isApproved =
                reservations.any((res) => res.status == "Approved");
            final borderColor = isApproved ? Colors.redAccent : Colors.amber;

            return Container(
              alignment: Alignment.center,
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 2,
                ),
              ),
              child: Text(
                '${day.day}',
                style: TextStyle(
                    color: isPastDate ? Colors.grey[300] : Colors.black),
              ),
            );
          } else if (isPastDate) {
            return Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors
                    .grey[300], // Light grey background for disabled past dates
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                    color: Colors.black54), // Text in white for disabled dates
              ),
            );
          }
          return null;
        },
        markerBuilder: (context, day, events) {
          final formattedDate = DateFormat('yyyy-MM-dd').format(day);
          if (reservationsByDate.containsKey(formattedDate)) {
            final reservations = reservationsByDate[formattedDate]!;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: reservations.take(3).map((reservation) {
                final user = reservation.user;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundImage: user?.profilePicture != null
                        ? NetworkImage(
                            '${dotenv.env['BASE_URL']}${user?.profilePicture!}')
                        : null,
                    child: user?.profilePicture == null
                        ? const Icon(Icons.person, size: 8)
                        : null,
                  ),
                );
              }).toList(),
            );
          }
          return null;
        },
      ),
      onDaySelected: (selectedDay, _) {
        if (!selectedDay.isBefore(today)) {
          // Allow selection only for dates today or in the future
          onDaySelected(selectedDay);
        }
      },
    );
  }
}
