import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vroom_app/components/RegistrationForm.dart';
import 'package:vroom_app/models/city.dart';
import 'package:vroom_app/services/CityService.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Forma
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
  int? _selectedCityId;
  File? _pickedImage;
  bool _isLoadingCities = false;

  List<City> _cities = [];

  @override
  void initState() {
    super.initState();
    _fetchCities(); 
  }


  Future<void> _fetchCities() async {
    setState(() => _isLoadingCities = true);
    try {
      final cityService = CityService();
      final fetched = await cityService.fetchCities();
      setState(() {
        _cities = fetched;
      });
    } catch (e) {
      debugPrint('Greška pri dohvatu gradova: $e');
      // Možeš i ovde da prikažeš toast
      Fluttertoast.showToast(
        msg: 'Greška pri dohvatu gradova.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => _isLoadingCities = false);
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email je obavezan.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Unesite validan email.';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Broj telefona je obavezan.';
    }
    final phoneRegex = RegExp(r'^\+387\d{8,9}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Format: +387XXXXXXXX (8-9 brojeva).';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lozinka je obavezna.';
    }
    if (value.length < 6) {
      return 'Lozinka mora imati bar 6 karaktera.';
    }
    return null;
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> pickDate() async {
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

  Future<void> registerUser() async {
    // 5.1) Validacija forme
    if (!_formKey.currentState!.validate()) return;

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
      final url = Uri.parse('http://localhost:5194/User');
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
      request.fields['dateOfBirth'] = _selectedDate!.toIso8601String();
      request.fields['cityId'] = _selectedCityId.toString();

      // Ako ima upload slike
      if (_pickedImage != null) {
        final fileBytes = await _pickedImage!.readAsBytes();
        final multiPart = http.MultipartFile.fromBytes(
          'profilePicture',
          fileBytes,
          filename: 'profile.jpg',
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
        debugPrint('Odgovor servera: ${response.body}');
        Fluttertoast.showToast(
          msg: 'Greška: ${response.statusCode}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Greška: $e');
      Fluttertoast.showToast(
        msg: 'Greška: $e',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: RegistrationForm(
          formKey: _formKey,

          // Kontroleri
          userNameController: _userNameController,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          emailController: _emailController,
          phoneNumberController: _phoneNumberController,
          adressController: _adressController,
          genderController: _genderController,
          passwordController: _passwordController,
          passwordConfController: _passwordConfController,

          // Date
          selectedDate: _selectedDate,
          onPickDate: pickDate,

          // City
          cities: _cities,
          selectedCityId: _selectedCityId,
          isLoadingCities: _isLoadingCities,
          onCityChanged: (val) {
            setState(() => _selectedCityId = val);
          },

          // Slika
          pickedImage: _pickedImage,
          onPickImage: pickImage,

          // Callback za registraciju
          onRegister: registerUser,

          // Validacije
          validateEmail: validateEmail,
          validatePhone: validatePhone,
          validatePassword: validatePassword,
        ),
      ),
    );
  }
}
