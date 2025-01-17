import 'package:flutter/material.dart';
import 'package:vroom_app/components/LoginButton.dart';
import 'package:vroom_app/components/ProfileCard.dart';
import 'package:vroom_app/components/ProfileHeader.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';
import 'package:vroom_app/screens/EditProfileScreen.dart';
import 'package:vroom_app/services/ApiConfig.dart';
import 'package:vroom_app/services/AuthService.dart';
import 'package:vroom_app/services/UserService.dart';
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
      final profile = await UserService.getUserProfile();
      setState(() {
        userProfile = profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ToastUtils.showErrorToast(message: "Greška tokom dohvata profila");
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

    // Ekstrakcija polja
    final String ime = userProfile!["firstName"] ?? '';
    final String prezime = userProfile!["lastName"] ?? '';
    final String userName = userProfile!["userName"] ?? "N/A";
    final String email = userProfile!["email"] ?? "N/A";
    final String phone = userProfile!["phoneNumber"] ?? "N/A";
    final String address = userProfile!["adress"] ?? "N/A";
    final String dob = formatDate(userProfile!["dateOfBirth"]);
    final String city = userProfile?["city"]?["title"] ?? "Nepoznat grad";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header sa slikom, Edit i Logout dugmad
            Center(
              child: ProfileHeader(
                profileImageUrl: userProfile!["profilePicture"] != null
                    ? "${ApiConfig.baseUrl}${userProfile!["profilePicture"]}"
                    : null,
                onEdit: () async {
                  final updatedProfile = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(userProfile: userProfile!),
                    ),
                  );

                  if (updatedProfile != null) {
                    setState(() {
                      userProfile = updatedProfile;
                    });
                  }
                },
                onLogout: () async {
                  await AuthService.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),

            // Kartice sa profilnim podacima
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileCard(
                    label: "Ime",
                    value: ime,
                  ),
                  ProfileCard(
                    label: "Prezime",
                    value: prezime,
                  ),
                  ProfileCard(
                    label: "Korisničko ime",
                    value: userName,
                  ),
                  ProfileCard(
                    label: "Email",
                    value: email,
                  ),
                  ProfileCard(
                    label: "Telefon",
                   value: formatPhoneNumber(phone),
                  ),
                  ProfileCard(
                    label: "Adresa",
                    value: address,
                  ),
                  ProfileCard(
                    label: "Datum rođenja",
                    value: dob,
                  ),
                  ProfileCard(
                    label: "Grad",
                    value: city
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