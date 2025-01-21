import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String? profileImageUrl;
  final VoidCallback onEdit;
  final VoidCallback onLogout;
  final VoidCallback onReservations;

  const ProfileHeader({
    Key? key,
    required this.profileImageUrl,
    required this.onEdit,
    required this.onLogout,
    required this.onReservations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background container sa gradientom
        Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade800, Colors.teal.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar sa belim obrubom
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: profileImageUrl == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.teal.shade200,
                    width: 2,
                  ),
                  backgroundColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Uredi profil",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Dugme za "Pogledaj rezervacije"
              ElevatedButton.icon(
                onPressed: onReservations,
                icon: const Icon(
                  Icons.event,
                  color: Colors.white,
                ),
                label: const Text(
                  "Pogledaj rezervacije",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade800,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Logout dugme (ikona + tekst) u gornjem desnom uglu
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: onLogout,
              ),
              const Text(
                'Odjava',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
