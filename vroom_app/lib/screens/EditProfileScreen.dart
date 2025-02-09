import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';
import 'package:vroom_app/models/canton.dart';
import 'package:vroom_app/models/city.dart';
import 'package:vroom_app/services/AutmobileDropDownService.dart';
import 'package:vroom_app/services/UserService.dart';
import 'package:vroom_app/utils/helpers.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;

  const EditProfileScreen({Key? key, required this.userProfile})
      : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Map<String, dynamic> editedProfile;
  List<City> cities = [];
  City? selectedCity;
  bool isLoadingCities = true;
  String? profileImagePath;
  bool isLocalImage = false;

  @override
  void initState() {
    super.initState();
    editedProfile = Map.from(widget.userProfile);
    profileImagePath = widget.userProfile["profilePicture"];
    fetchCities();
  }

  Future<void> fetchCities() async {
    try {
      final service = AutomobileDropDownService();
      final fetchedCities = await service.fetchCities();
      setState(() {
        cities = fetchedCities;
        final cityId = widget.userProfile["cityId"];
        if (cityId != null) {
          selectedCity = cities.firstWhere(
            (city) => city.id == cityId,
            orElse: () => City(
              id: cityId,
              title: "Nepoznat grad",
              canton: Canton(
                id: 0,
                title: "Nepoznat kanton",
              ),
            ),
          );
        }
        isLoadingCities = false;
      });
    } catch (e) {
      setState(() {
        isLoadingCities = false;
      });
    }
  }

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImagePath = image.path;
        isLocalImage = true;
        editedProfile["profilePicture"] = image.path;
      });
      print("Selected image path: $profileImagePath");
    }
  }

  void _saveChanges() async {
    try {
      editedProfile["cityId"] = selectedCity?.id;

      editedProfile.remove("city");

      File? profilePictureFile;
      bool isImageUpdated = false;

      if (isLocalImage && profileImagePath != null) {
        profilePictureFile = File(profileImagePath!);
        isImageUpdated = true;
      }

      final response = await UserService.updateUserProfile(
        userId: widget.userProfile["id"],
        userData: editedProfile,
        profilePicture: profilePictureFile,
        isImageUpdated: isImageUpdated,
      );

      if (response != null) {
        ToastUtils.showToast(message: "Profil uspešno ažuriran!");
        Navigator.pop(context, response);
      } else {
        ToastUtils.showErrorToast(message: "Profil nije ažuriran!");
      }
    } catch (e) {
      ToastUtils.showErrorToast(message: "Greška: $e");
    }
  }

  Widget _buildDatePickerField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: editedProfile[key] != null
                ? DateTime.parse(editedProfile[key])
                : DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              editedProfile[key] = pickedDate.toIso8601String();
            });
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            editedProfile[key] != null
                ? formatDate(editedProfile[key])
                : "Odaberite datum",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uredi profil"),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(
          color: Colors.blueAccent,
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(
              Icons.save,
              color: Colors.blueAccent,
            ),
            label: const Text(
              'Sačuvaj',
              style: TextStyle(color: Colors.blueAccent),
            ),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: isLoadingCities
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileImage(),
                  _buildEditableField("Ime", "firstName"),
                  _buildEditableField("Prezime", "lastName"),
                  _buildEditableField("Email", "email"),
                  _buildEditableField("Telefon", "phoneNumber"),
                  _buildEditableField("Adresa", "adress"),
                  _buildDatePickerField("Datum rođenja", "dateOfBirth"),
                  const SizedBox(height: 16),
                  _buildCityDropdown(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: profileImagePath != null
                ? (isLocalImage
                    ? FileImage(File(profileImagePath!))
                    : NetworkImage("${dotenv.env['BASE_URL']}$profileImagePath")
                        as ImageProvider<Object>)
                : const AssetImage('assets/default_avatar.png')
                    as ImageProvider<Object>,
          ),
          TextButton.icon(
            onPressed: pickProfileImage,
            icon: const Icon(Icons.camera_alt),
            label: const Text("Promijeni sliku"),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        controller: TextEditingController(text: editedProfile[key]),
        onChanged: (value) {
          editedProfile[key] = value;
        },
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<City>(
        value: selectedCity,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: "Grad",
          border: OutlineInputBorder(),
        ),
        items: cities.map((city) {
          return DropdownMenuItem<City>(
            value: city,
            child: Text(city.title),
          );
        }).toList(),
        onChanged: (City? newCity) {
          setState(() {
            selectedCity = newCity;
          });
        },
      ),
    );
  }
}
