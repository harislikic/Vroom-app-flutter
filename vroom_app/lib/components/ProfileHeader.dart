import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String? profileImageUrl;
  final VoidCallback onEdit;

  const ProfileHeader({
    Key? key,
    required this.profileImageUrl,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200, // Visina za pozadinski deo
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            "https://img.freepik.com/free-vector/colorful-gradient-background-modern-design_361591-4093.jpg?t=st=1734703571~exp=1734707171~hmac=576932a3aa54197a728d2abc658730781b594380a3f3f9a1d2e75a35b7dacdd9&w=360",
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0, // Remove elevation to keep it flat
            ).copyWith(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Colors.blue[900]!, // Blue 900 border color
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            child: const Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.black, // Black text color
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
