import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vroom_app/models/city.dart';
import 'package:vroom_app/screens/RegisterScreen.dart';

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

  final Gender? selectedGender;
  final ValueChanged<Gender?> onGenderChanged;

  const RegistrationForm({
    Key? key,
    required this.formKey,
    required this.userNameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneNumberController,
    required this.adressController,
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
    this.onRemoveImage,
    required this.selectedGender,
    required this.onGenderChanged,
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
            decoration: const InputDecoration(
              labelText: "Telefon",
              prefixText: '+387 ', // Ovde ubaci prefiks
            ),
            keyboardType: TextInputType.phone,
            validator: widget.validatePhone,
          ),
          // Adresa
          TextFormField(
            controller: widget.adressController,
            decoration: const InputDecoration(labelText: "Adresa"),
            validator: (val) =>
                val == null || val.isEmpty ? "Polje obavezno" : null,
          ),
          // Spol
          FormField<Gender>(
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormField<Gender>(
                    validator: (value) {
                      // Ako korisnik nije izabrao pol, vrati grešku
                      if (value == null) {
                        return 'Polje obavezno';
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio<Gender>(
                                value: Gender.male,
                                groupValue: widget.selectedGender,
                                onChanged: (val) {
                                  field.didChange(val);
                                  widget.onGenderChanged(val);
                                },
                              ),
                              const Text('Muški (M)'),
                              SizedBox(width: 20),
                              Radio<Gender>(
                                value: Gender.female,
                                groupValue: widget.selectedGender,
                                onChanged: (val) {
                                  field.didChange(val);
                                  widget.onGenderChanged(val);
                                },
                              ),
                              const Text('Ženski (Z)'),
                            ],
                          ),
                          if (field.hasError)
                            Text(
                              field.errorText ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                        ],
                      );
                    },
                  ),

                  // Ako validator vrati grešku, prikaži ispod
                  if (field.hasError)
                    Text(
                      field.errorText ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              );
            },
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
          FormField<DateTime>(
            validator: (value) {
              if (widget.selectedDate == null) {
                return "Morate izabrati datum rođenja.";
              }
              return null;
            },
            builder: (FormFieldState<DateTime> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      widget.onPickDate();
                      field.didChange(widget
                          .selectedDate); // Obavesti formu da je vrednost promenjena
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Datum rođenja",
                        errorText:
                            field.errorText, // Prikazuje grešku ako postoji
                      ),
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
                ],
              );
            },
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
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 2,
                                offset: Offset(2, 2),
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

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
