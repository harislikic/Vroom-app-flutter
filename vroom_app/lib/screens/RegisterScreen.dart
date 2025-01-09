import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vroom_app/components/RegistrationForm.dart';
import 'package:vroom_app/models/city.dart';
import 'package:vroom_app/services/CityService.dart';

import '../services/ApiConfig.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Kontroleri za polja
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfController = TextEditingController();

  DateTime? _selectedDate;
  bool _isAdmin = false;
  int? _selectedCityId;
  File? _pickedImage;

  List<City> _cities = [];
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    setState(() {
      _isLoadingCities = true;
    });
    try {
      final cityService = CityService();
      final fetched = await cityService.fetchCities();
      setState(() {
        _cities = fetched;
      });
    } catch (e) {
      print('Greška pri dohvatu gradova: $e');
      Fluttertoast.showToast(
        msg: 'Greška pri dohvatu gradova.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  // Validacije
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email je obavezan.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Unesite validan email.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Broj telefona je obavezan.';
    }
    final phoneRegex = RegExp(r'^\+387\d{8,9}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Format: +387XXXXXXXX (8-9 brojeva).';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lozinka je obavezna.';
    }
    if (value.length < 6) {
      return 'Lozinka mora imati bar 6 karaktera.';
    }
    return null;
  }

  // Odabir slike
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  // Uklanjanje slike
  void _removePickedImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  // Odabir datuma
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 18);
    final newDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
      });
    }
  }

  // Registracija korisnika
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _passwordConfController.text) {
      Fluttertoast.showToast(
        msg: 'Lozinke se ne poklapaju!',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_selectedDate == null) {
      Fluttertoast.showToast(
        msg: 'Morate izabrati datum rođenja!',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_selectedCityId == null) {
      Fluttertoast.showToast(
        msg: 'Morate izabrati grad!',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/User');
      final request = http.MultipartRequest('POST', url);
      request.headers['Content-Type'] = 'multipart/form-data';

      // Polja
      request.fields['userName'] = _userNameController.text;
      request.fields['firstName'] = _firstNameController.text;
      request.fields['lastName'] = _lastNameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phoneNumber'] = _phoneNumberController.text;
      request.fields['adress'] = _adressController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['password'] = _passwordController.text;
      request.fields['passwordConfirmation'] = _passwordConfController.text;
      request.fields['isAdmin'] = _isAdmin.toString();
      request.fields['dateOfBirth'] = _selectedDate!.toIso8601String();
      request.fields['cityId'] = _selectedCityId.toString();

      // Ako ima upload slike
      if (_pickedImage != null) {
        final fileBytes = await _pickedImage!.readAsBytes();
        final fileName = _pickedImage!.path.split('/').last;
        final multiPart = http.MultipartFile.fromBytes(
          'profilePicture',
          fileBytes,
          filename: fileName, // Koristi originalni naziv fajla
        );
        request.files.add(multiPart);
      }

      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Uspešno kreiran profil!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final responseBody = response.body;

        // Definišite poruku greške
        String errorMessage = 'Došlo je do greške. Pokušajte ponovo.';

        // Ako odgovor sadrži specifičan tekst, prilagodite poruku greške
        if (responseBody.contains(
            'A user with the same username or email already exists')) {
          errorMessage =
              'Korisnik sa istim korisničkim imenom ili emailom već postoji.';
        } else if (responseBody.contains('Internal Server Error')) {
          errorMessage = 'Greška na serveru. Pokušajte ponovo kasnije.';
        }

        // Prikazivanje poruke greške kao Toast
        Fluttertoast.showToast(
          msg: errorMessage,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      print('Greška: $e');
      String errorMessage = 'Došlo je do greške. Pokušajte ponovo.';

      if (e
          .toString()
          .contains('A user with the same username or email already exists')) {
        errorMessage =
            'Korisnik sa istim korisničkim imenom ili emailom već postoji.';
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registracija"),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: RegistrationForm(
          formKey: _formKey,
          userNameController: _userNameController,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          emailController: _emailController,
          phoneNumberController: _phoneNumberController,
          adressController: _adressController,
          genderController: _genderController,
          passwordController: _passwordController,
          passwordConfController: _passwordConfController,
          selectedDate: _selectedDate,
          onPickDate: _pickDate,
          cities: _cities,
          selectedCityId: _selectedCityId,
          isLoadingCities: _isLoadingCities,
          onCityChanged: (val) {
            setState(() {
              _selectedCityId = val;
            });
          },
          pickedImage: _pickedImage,
          onPickImage: _pickImage,
          onRegister: _registerUser,
          validateEmail: _validateEmail,
          validatePhone: _validatePhone,
          validatePassword: _validatePassword,
          onRemoveImage:
              _removePickedImage, // Implementiraj callback za uklanjanje slike
        ),
      ),
    );
  }
}
