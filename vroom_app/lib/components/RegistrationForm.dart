import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vroom_app/models/city.dart';

class RegistrationForm extends StatefulWidget {
  // Forma
  final GlobalKey<FormState> formKey;

  // Kontroleri
  final TextEditingController userNameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;
  final TextEditingController adressController;
  final TextEditingController genderController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfController;

  // Datum
  final DateTime? selectedDate;
  final VoidCallback onPickDate;

  // Grad
  final List<City> cities;
  final int? selectedCityId;
  final bool isLoadingCities;
  final ValueChanged<int?> onCityChanged;

  // Slika
  final File? pickedImage;
  final VoidCallback onPickImage;

  // Registracija
  final VoidCallback onRegister;

  // Validacije
  final String? Function(String?)? validateEmail;
  final String? Function(String?)? validatePhone;
  final String? Function(String?)? validatePassword;

  // Dodato: Callback za uklanjanje slike
  final VoidCallback? onRemoveImage;

  const RegistrationForm({
    Key? key,
    required this.formKey,
    required this.userNameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneNumberController,
    required this.adressController,
    required this.genderController,
    required this.passwordController,
    required this.passwordConfController,
    required this.selectedDate,
    required this.onPickDate,
    required this.cities,
    required this.selectedCityId,
    required this.isLoadingCities,
    required this.onCityChanged,
    required this.pickedImage,
    required this.onPickImage,
    required this.onRegister,
    this.validateEmail,
    this.validatePhone,
    this.validatePassword,
    this.onRemoveImage, // Dodato: Callback za uklanjanje slike
  }) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  // Za prikaz/sakrivanje password polja
  bool _obscurePass = true;
  bool _obscurePassConf = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey, // Važno za validaciju
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Username
          TextFormField(
            controller: widget.userNameController,
            decoration: const InputDecoration(labelText: "Korisničko ime"),
            validator: (val) =>
                val == null || val.isEmpty ? "Polje obavezno" : null,
          ),
          // FirstName
          TextFormField(
            controller: widget.firstNameController,
            decoration: const InputDecoration(labelText: "Ime"),
            validator: (val) =>
                val == null || val.isEmpty ? "Polje obavezno" : null,
          ),
          // LastName
          TextFormField(
            controller: widget.lastNameController,
            decoration: const InputDecoration(labelText: "Prezime"),
            validator: (val) =>
                val == null || val.isEmpty ? "Polje obavezno" : null,
          ),
          // Email
          TextFormField(
            controller: widget.emailController,
            decoration: const InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
            validator: widget.validateEmail,
          ),
          // Telefon
          TextFormField(
            controller: widget.phoneNumberController,
            decoration: const InputDecoration(labelText: "Telefon"),
            validator: widget.validatePhone,
          ),
          // Adresa
          TextFormField(
            controller: widget.adressController,
            decoration: const InputDecoration(labelText: "Adresa"),
          ),
          // Spol
          TextFormField(
            controller: widget.genderController,
            decoration: const InputDecoration(labelText: "Spol (M/F)"),
          ),

          // Lozinka
          TextFormField(
            controller: widget.passwordController,
            decoration: InputDecoration(
              labelText: "Lozinka",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePass ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePass = !_obscurePass;
                  });
                },
              ),
            ),
            obscureText: _obscurePass,
            validator: widget.validatePassword,
          ),

          // Potvrda lozinke
          TextFormField(
            controller: widget.passwordConfController,
            decoration: InputDecoration(
              labelText: "Potvrda lozinke",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassConf ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassConf = !_obscurePassConf;
                  });
                },
              ),
            ),
            obscureText: _obscurePassConf,
            validator: widget.validatePassword,
          ),

          const SizedBox(height: 10),

          // Date of Birth
          InkWell(
            onTap: widget.onPickDate,
            child: InputDecorator(
              decoration: const InputDecoration(labelText: "Datum rođenja"),
              child: Text(
                widget.selectedDate == null
                    ? 'Izaberite datum'
                    : widget.selectedDate!
                        .toLocal()
                        .toString()
                        .split(' ')[0],
              ),
            ),
          ),

          // Grad (dropdown)
          const SizedBox(height: 10),
          widget.isLoadingCities
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: "Grad"),
                  value: widget.selectedCityId,
                  items: widget.cities.map((city) {
                    return DropdownMenuItem<int>(
                      value: city.id,
                      child: Text(city.title),
                    );
                  }).toList(),
                  onChanged: widget.onCityChanged,
                  validator: (val) =>
                      val == null ? "Morate izabrati grad." : null,
                ),

          const SizedBox(height: 10),

          // Slika sa X dugmetom
          Row(
            children: [
              ElevatedButton(
                onPressed: widget.onPickImage,
                child: const Text("Odaberi sliku"),
              ),
              const SizedBox(width: 10),
              if (widget.pickedImage != null)
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      // GestureDetector za prikaz slika u modalu
                      GestureDetector(
                        onTap: () {
                          // Otvorimo dijalog za prikaz pune slike
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return Dialog(
                                child: PhotoView(
                                  imageProvider: FileImage(widget.pickedImage!),
                                  backgroundDecoration:
                                      const BoxDecoration(color: Colors.black),
                                  minScale: PhotoViewComputedScale.contained,
                                  maxScale: PhotoViewComputedScale.covered * 3,
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 2,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              widget.pickedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // X (close) dugme u gornjem desnom uglu
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () {
                            // Pozovi callback za uklanjanje slike
                            if (widget.onRemoveImage != null) {
                              widget.onRemoveImage!();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Text("Nema slike"),
            ],
          ),

          const SizedBox(height: 20),

          // Dugme za registraciju
          ElevatedButton(
            onPressed: widget.onRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[900],
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
            ),
            child: const Text(
              "Registruj se",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
