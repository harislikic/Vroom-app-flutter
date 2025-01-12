import 'package:flutter/material.dart';
import 'package:vroom_app/models/city.dart';
import 'package:vroom_app/services/CityService.dart';
import 'package:vroom_app/models/carBrand.dart';
import 'package:vroom_app/models/carCategory.dart';
import 'package:vroom_app/models/carModel.dart';

import '../services/AutmobileDropDownService.dart';

class FilterForm extends StatefulWidget {
  final Function(String, String, String, String, String, bool, String, String,
      String, String) onApplyFilters;
  final Function() onResetFilters;

  const FilterForm({
    Key? key,
    required this.onApplyFilters,
    required this.onResetFilters,
  }) : super(key: key);

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

  String? _selectedCarBrandId;
  String? _selectedCarCategoryId;
  String? _selectedCarModelId;
  String? _selectedCityId;

  List<CarBrand> _carBrands = [];
  List<CarCategory> _carCategories = [];
  List<CarModel> _carModels = [];
  List<City> _cities = [];

  final CityService _cityService = CityService();

  final AutomobileDropDownService _dropDownService =
      AutomobileDropDownService();

  Future<void> _fetchAutomobileDropDownData() async {
    try {
      final carBrands = await _dropDownService.fetchCarBrands();
      final carCategories = await _dropDownService.fetchCarCategories();
      final carModels = await _dropDownService.fetchCarModels();
      final cities = await _cityService.fetchCities();

      setState(() {
        _carBrands = carBrands;
        _carCategories = carCategories;
        _carModels = carModels;
        _cities = cities;
      });
    } catch (e) {
      print('Failed to fetch dropDowns data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAutomobileDropDownData();
  }

  void _applyFilters() {
    widget.onApplyFilters(
      _minPriceController.text,
      _maxPriceController.text,
      _minMileageController.text,
      _maxMileageController.text,
      _yearOfManufactureController.text,
      _isRegistered,
      _selectedCarBrandId ?? '',
      _selectedCarCategoryId ?? '',
      _selectedCarModelId ?? '',
      _selectedCityId ?? '',
    );
  }

  void _resetFilters() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _minMileageController.clear();
      _maxMileageController.clear();
      _yearOfManufactureController.clear();
      _isRegistered = false;
      _selectedCarBrandId = null;
      _selectedCarCategoryId = null;
      _selectedCarModelId = null;
      _selectedCityId = null;
    });
    widget.onResetFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Min and Max Price
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Min Cijena'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Max Cijena'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Min and Max Mileage
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minMileageController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Min Kilometraža'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _maxMileageController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Max Kilometraža'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Year of Manufacture
          TextFormField(
            controller: _yearOfManufactureController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Godina Proizvodnje'),
          ),
          const SizedBox(height: 10),

          // Registered Checkbox
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
          const SizedBox(height: 10),

          // Filter Dropdowns
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCarBrandId,
                      items: _carBrands
                          .map((brand) => DropdownMenuItem(
                                value: brand.id.toString(),
                                child: Text(
                                  brand.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCarBrandId = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Brend',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCarCategoryId,
                      items: _carCategories
                          .map((category) => DropdownMenuItem(
                                value: category.id.toString(),
                                child: Text(
                                  category.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCarCategoryId = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Kategorija',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                      ),
                      isDense: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCarModelId,
                      items: _carModels
                          .map((model) => DropdownMenuItem(
                                value: model.id.toString(),
                                child: Text(
                                  model.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCarModelId = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Model',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(width: 10), // Added spacing
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCityId,
                      items: _cities
                          .map((city) => DropdownMenuItem(
                                value: city.id.toString(),
                                child: Text(
                                  city.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCityId = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Grad',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                      ),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Filter and Reset Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _applyFilters,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_list, size: 20.0),
                    SizedBox(width: 8),
                    Text('Filtriraj'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _resetFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blueGrey[600]!, width: 2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, size: 20.0, color: Colors.blueGrey),
                    SizedBox(width: 8),
                    Text('Očisti Filtere'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
