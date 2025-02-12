import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vroom_app/models/myReservation.dart';
import 'package:vroom_app/screens/automobileDetailsScreen.dart';
import 'package:vroom_app/services/config.dart';

class MyReservationCard extends StatelessWidget {
  final MyReservation reservation;
  final VoidCallback? onDelete;

  const MyReservationCard({
    Key? key,
    required this.reservation,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AutomobileDetailsScreen(
                        automobileAdId: reservation.automobile.id,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    "$baseUrl${reservation.automobile.firstImage}",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservation.automobile.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${NumberFormat('#,##0').format(reservation.automobile.price)} KM",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: reservation
                                  .automobile.user.profilePicture.isNotEmpty
                              ? NetworkImage(
                                  "$baseUrl${reservation.automobile.user.profilePicture}")
                              : const AssetImage(
                                  'assets/default_profile.png',
                                ) as ImageProvider,
                          backgroundColor: Colors.grey.shade200,
                        ),
                        const SizedBox(width: 8),

                        Text(
                          reservation.automobile.user.userName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    Text(
                      "Napravili ste rezervaciju dana ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(reservation.reservationDate))}.",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: reservation.status == "Pending" ? null : onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: reservation.status == "Pending"
                      ? Colors.grey.shade300 
                      : Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                icon: Icon(
                  reservation.status == "Pending"
                      ? Icons.hourglass_empty 
                      : Icons.delete,
                  color: reservation.status == "Pending"
                      ? Colors.grey
                      : Colors.red,
                ),
                label: Text(
                  reservation.status == "Pending"
                      ? "Rezervacija u obradi"
                      : "Otkaži rezervaciju",
                  style: TextStyle(
                    color: reservation.status == "Pending"
                        ? Colors.black54
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
