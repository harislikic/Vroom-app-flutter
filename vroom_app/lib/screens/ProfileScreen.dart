import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroom_app/components/LoginButton.dart';
import 'package:vroom_app/components/ProfileCard.dart';
import 'package:vroom_app/components/ProfileHeader.dart';
import 'package:vroom_app/services/AuthService.dart';
import 'package:vroom_app/utils/helpers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final userId = await AuthService.getUserId();
      if (userId == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final headers = await AuthService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('http://localhost:5194/User/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        setState(() {
          userProfile = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greška: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška tokom dohvata profila: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProfile == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Morate se prijaviti da vidite svoj profil.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            LoginButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header without padding
            Center(
              child: ProfileHeader(
                profileImageUrl: userProfile!["profilePicture"] != null
                    ? "http://localhost:5194${userProfile!["profilePicture"]}"
                    : null,
                onEdit: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
              ),
            ),
            const SizedBox(height: 20),
            // Content with padding applied here
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileCard(
                    label: "Ime i prezime",
                    value:
                        "${userProfile!["firstName"]} ${userProfile!["lastName"]}",
                  ),
                  ProfileCard(
                    label: "Korisničko ime",
                    value: userProfile!["userName"] ?? "N/A",
                  ),
                  ProfileCard(
                    label: "Email",
                    value: userProfile!["email"] ?? "N/A",
                  ),
                  ProfileCard(
                    label: "Telefon",
                    value: userProfile!["phoneNumber"] ?? "N/A",
                  ),
                  ProfileCard(
                    label: "Adresa",
                    value: userProfile!["adress"] ?? "N/A",
                  ),
                  ProfileCard(
                    label: "Datum rođenja",
                    value: formatDate(userProfile!["dateOfBirth"]),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await AuthService.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.blueGrey[200]!, // Blue 900 border color
                          width: 2,
                        ),
                        backgroundColor: Colors.transparent, // Transparent background
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0, // Remove elevation for a flat button
                      ),
                      child: const Text(
                        "Odjavi se",
                        style: TextStyle(
                          color: Colors.black, // Black text color
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
