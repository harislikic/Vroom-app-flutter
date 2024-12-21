import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String? profileImageUrl;
  final VoidCallback onEdit;
  final VoidCallback onLogout;

  const ProfileHeader({
    Key? key,
    required this.profileImageUrl,
    required this.onEdit,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background container with image
        Container(
          width: double.infinity,
          height: 200, // Height for the background section
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "https://img.freepik.com/free-vector/green-neon-lined-pattern-dark-social-story-background-vector_53876-173385.jpg?t=st=1734779472~exp=1734783072~hmac=553f18be68bda9963fe60f566c45ab52207e84f69a6dfde84d4bffb276ae7a71&w=740",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle avatar with border
              Container(
                padding: const EdgeInsets.all(4), // Border width
                decoration: BoxDecoration(
                  color: Colors.white, // Border color
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
              // Edit profile button
              ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.blueGrey[400]!, // Blue 900 border color
                    width: 2,
                  ),
                  backgroundColor: Colors.transparent, // Transparent background
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0, // Remove elevation to keep it flat
                ),
                child: const Text(
                  "Uredi profil",
                  style: TextStyle(
                    color: Colors.lightBlueAccent, // Black text color
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ),
        // Logout button in the top right corner
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.blueGrey, // Logout icon color
                  size: 30, // Size of the icon
                ),
                onPressed: onLogout, // Logout action
              ),
              const Text(
                'Odjava',
                style: TextStyle(
                  color: Colors.blueGrey, // Text color
                  fontSize: 16, // Text size
                  fontWeight: FontWeight.w600, // Text weight
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
