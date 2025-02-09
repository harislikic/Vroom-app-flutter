import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:vroom_app/models/reservation.dart';
import 'package:vroom_app/screens/automobileDetailsScreen.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback? onApprove; // Optional for delete-only scenarios
  final VoidCallback? onDecline; // Optional for delete-only scenarios
  final VoidCallback? onDelete; // New onDelete callback

  const ReservationCard({
    Key? key,
    required this.reservation,
    this.onApprove, // Made optional
    this.onDecline, // Made optional
    required this.onDelete, // Required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        children: [
          // Top section with car image and user profile
          Row(
            children: [
              // Car image
              // Car image with onTap
              GestureDetector(
                onTap: () {
                  // Navigate to ad details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AutomobileDetailsScreen(
                        automobileAdId: reservation.automobileAdId!,
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
                    "${dotenv.env['BASE_URL']}${reservation.firstImage}",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),
              // Reservation details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservation.title ?? "N/A",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${NumberFormat('#,##0').format(reservation.price ?? 0)} KM",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black, // Black text for the price
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // User profile picture
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: reservation.user?.profilePicture !=
                                  null
                              ? NetworkImage(
                                  "${dotenv.env['BASE_URL']}${reservation.user?.profilePicture}")
                              : const AssetImage(
                                  'assets/default_profile.png',
                                ) as ImageProvider,
                          backgroundColor: Colors.grey.shade200,
                        ),
                        const SizedBox(width: 8),
                        // Username
                        Text(
                          reservation.user?.userName ?? "N/A",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Želi da napravi rezervaciju dana ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(reservation.reservationDate))}.",
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
          // Bottom section with action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Prikazuje dugmad "Odobri" i "Odbi" samo za status "Pending"
              if (reservation.status == "Pending") ...[
                ElevatedButton.icon(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.green, // Zeleni obrub
                      width: 2, // Debljina obruba
                    ),
                    backgroundColor: Colors.white, // Providna pozadina
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  icon: const Icon(Icons.check, color: Colors.black), // Ikona
                  label: const Text(
                    "Odobri",
                    style: TextStyle(color: Colors.black), // Crni tekst
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onDecline,
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.red, // Crveni obrub
                      width: 2, // Debljina obruba
                    ),
                    backgroundColor: Colors.white, // Providna pozadina
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  icon: const Icon(Icons.cancel,
                      color: Colors.red), // Trash can ikona
                  label: const Text(
                    "Odbi",
                    style: TextStyle(color: Colors.black), // Crni tekst
                  ),
                ),
              ],

              // Prikazuje dugme "Obriši" za statuse "Approved" i "Declined"
              if (reservation.status == "Approved" ||
                  reservation.status == "Rejected")
                ElevatedButton.icon(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Obriši",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
