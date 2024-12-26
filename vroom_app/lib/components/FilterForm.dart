import 'package:flutter/material.dart';

class FilterForm extends StatefulWidget {
  final Function(String, String, String, String, String, bool) onApplyFilters;
  final Function() onResetFilters; // Dodajemo funkciju za resetovanje

  const FilterForm(
      {Key? key, required this.onApplyFilters, required this.onResetFilters})
      : super(key: key);

  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _minMileageController = TextEditingController();
  final TextEditingController _maxMileageController = TextEditingController();
  final TextEditingController _yearOfManufactureController =
      TextEditingController();
  bool _isRegistered = false;

  // Primena filtera
  void _applyFilters() {
    widget.onApplyFilters(
      _minPriceController.text,
      _maxPriceController.text,
      _minMileageController.text,
      _maxMileageController.text,
      _yearOfManufactureController.text,
      _isRegistered,
    );
  }

  // Resetovanje filtera
  void _resetFilters() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _minMileageController.clear();
      _maxMileageController.clear();
      _yearOfManufactureController.clear();
      _isRegistered = false;
    });

    // Pozivanje funkcije koja resetuje filtere
    widget.onResetFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Min and Max Price in one row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Min Cijena',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Max Cijena',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Min and Max Mileage in one row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minMileageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Min Kilometraža',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _maxMileageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Max Kilometraža',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Year of Manufacture
          TextFormField(
            controller: _yearOfManufactureController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Godina Proizvodnje',
            ),
          ),
          const SizedBox(height: 10),

          // Registered (Checkbox)
          Row(
            children: [
              Checkbox(
                value: _isRegistered,
                onChanged: (bool? value) {
                  setState(() {
                    _isRegistered = value ?? false;
                  });
                },
              ),
              const Text('Registrovano'),
            ],
          ),
          const SizedBox(height: 20),

          // Filtriraj i Resetuj Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Dugme za filtriranje
              ElevatedButton(
                onPressed: _applyFilters,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.filter_list, // Ikona filtera
                      size: 20.0, // Veličina ikone
                    ),
                    SizedBox(width: 8), // Razmak između ikone i teksta
                    Text('Filtriraj'), // Tekst dugmeta
                  ],
                ),
              ),
              // Dugme za resetovanje filtera
              ElevatedButton(
                onPressed: _resetFilters,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.refresh, // Ikona za resetovanje
                      size: 20.0, // Veličina ikone
                      color: Colors.blueGrey, // Boja ikone
                    ),
                    SizedBox(width: 8), // Razmak između ikone i teksta
                    Text('Očisti Filtere'), // Tekst dugmeta
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blueGrey[600]!, width: 2),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
