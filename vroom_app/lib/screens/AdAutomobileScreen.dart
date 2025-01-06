import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vroom_app/components/ImagePicker.dart';
import 'package:vroom_app/services/AutomobileAdService.dart';
import 'package:vroom_app/services/EquipemntService.dart';
import 'package:vroom_app/services/carBrandService.dart';
import 'package:vroom_app/services/carCategoryService.dart';
import 'package:vroom_app/services/carModelService.dart';

import 'package:vroom_app/models/carBrand.dart';
import 'package:vroom_app/models/carCategory.dart';
import 'package:vroom_app/models/carModel.dart';
import 'package:vroom_app/models/fuelType.dart';
import 'package:vroom_app/models/transmissionType.dart';
import 'package:vroom_app/models/vehicleCondition.dart';
import 'package:vroom_app/services/fuelTypeService.dart';
import 'package:vroom_app/services/transmissionTypeService.dart';
import 'package:vroom_app/services/vehicleConditionService.dart';

import '../models/equipment.dart';
import '../services/AuthService.dart';

class AddAutomobileScreen extends StatefulWidget {
  const AddAutomobileScreen({Key? key}) : super(key: key);

  @override
  _AddAutomobileScreenState createState() => _AddAutomobileScreenState();
}

class _AddAutomobileScreenState extends State<AddAutomobileScreen> {
  bool _isLoading = false; // Loading state
  final _formKey = GlobalKey<FormState>();

  String? _title;
  String? _description;
  double? _price;
  int? _mileage;
  int? _yearOfManufacture;
  bool _isRegistered = false;
  DateTime? _registrationExpirationDate;
  DateTime? _lastSmallService;
  DateTime? _lastBigService;
  String? _carBrandId;
  String? _carCategoryId;
  String? _carModelId;
  String? _fuelTypeId;
  String? _transmissionTypeId;
  List<int> _equipmentIds = [];
  List<String> _selectedEquipmentNames = [];
  int? _enginePower;
  int? _numberOfDoors;
  int? _cubicCapacity;
  int? _horsePower;
  String? _color;
  String? _vehicleConditionId;

  List<Equipment> _equipment = [];
  List<CarBrand> _carBrands = [];
  List<CarCategory> _carCategories = [];
  List<CarModel> _carModels = [];
  List<FuelType> _fuelTypes = [];
  List<TransmissionType> _transmissionTypes = [];
  List<VehicleCondition> _vehicleConditions = [];
  List<XFile> _imageFiles = [];

  final CarBrandService _carBrandService = CarBrandService();
  final CarCategoryService _carCategoryService = CarCategoryService();
  final CarModelService _carModelService = CarModelService();
  final FuelTypeService _fuelTypeService = FuelTypeService();
  final TransmissionTypeService _transmissionTypeService =
      TransmissionTypeService();
  final VehicleConditionService _vehicleConditionService =
      VehicleConditionService();
  final EquipmentService _equipmentService = EquipmentService();

  @override
  void initState() {
    super.initState();
    _fetchCarBrands();
    _fetchCarCategories();
    _fetchCarModels();
    _fetchFuelTypes();
    _fetchTransmissionTypes();
    _fetchVehicleConditions();
    _fetchEquipments();
  }

  Future<void> _fetchCarBrands() async {
    try {
      final carBrands = await _carBrandService.fetchCarBrands();
      setState(() {
        _carBrands = carBrands;
      });
    } catch (e) {
      print('Failed to fetch car brands: $e');
    }
  }

  Future<void> _fetchCarCategories() async {
    try {
      final carCategories = await _carCategoryService.fetchCarCategories();
      setState(() {
        _carCategories = carCategories;
      });
    } catch (e) {
      print('Failed to fetch car categories: $e');
    }
  }

  Future<void> _fetchCarModels() async {
    try {
      final carModels = await _carModelService.fetchCarModels();
      setState(() {
        _carModels = carModels;
      });
    } catch (e) {
      print('Failed to fetch car models: $e');
    }
  }

  Future<void> _fetchFuelTypes() async {
    try {
      final fuelTypes = await _fuelTypeService.fetchFuelTypes();
      setState(() {
        _fuelTypes = fuelTypes;
      });
    } catch (e) {
      print('Failed to fetch fuel types: $e');
    }
  }

  Future<void> _fetchTransmissionTypes() async {
    try {
      final transmissionTypes =
          await _transmissionTypeService.fetchTransmissionTypes();
      setState(() {
        _transmissionTypes = transmissionTypes;
      });
    } catch (e) {
      print('Failed to fetch transmission types: $e');
    }
  }

  Future<void> _fetchVehicleConditions() async {
    try {
      final vehicleConditions =
          await _vehicleConditionService.fetchVehicleConditions();
      setState(() {
        _vehicleConditions = vehicleConditions;
      });
    } catch (e) {
      print('Failed to fetch vehicle conditions: $e');
    }
  }

  Future<void> _fetchEquipments() async {
    try {
      final equipmentList = await _equipmentService.fetchEquipments();
      setState(() {
        _equipment = equipmentList;
      });
    } catch (e) {
      print('Failed to fetch equipment: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime?) onDatePicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDatePicked(picked);
    }
  }

  // Helper function for formatting DateTime
  String? formatDateAds(DateTime? date) {
    if (date == null) return null;
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // Save the form data

      setState(() {
        _isLoading = true; // Postavi isLoading na true kada počne proces
      });

      final userId = await AuthService.getUserId();
      final authHeaders = await AuthService.getAuthHeaders();

      Map<String, dynamic> adData = {
        'Title': _title,
        'Description': _description,
        'Price': _price,
        'Mileage': _mileage,
        'YearOfManufacture': _yearOfManufacture,
        'Registered': _isRegistered,
        'RegistrationExpirationDate':
            formatDateAds(_registrationExpirationDate),
        'Last_Small_Service': formatDateAds(_lastSmallService),
        'Last_Big_Service': formatDateAds(_lastBigService),
        'UserId': userId,
        'CarBrandId': _carBrandId,
        'CarCategoryId': _carCategoryId,
        'CarModelId': _carModelId,
        'FuelTypeId': _fuelTypeId,
        'TransmissionTypeId': _transmissionTypeId,
        'EnginePower': _enginePower,
        'NumberOfDoors': _numberOfDoors,
        'CubicCapacity': _cubicCapacity,
        'HorsePower': _horsePower,
        'Color': _color,
        'VehicleConditionId': _vehicleConditionId,
      };

      // Dodaj svaki EquipmentId kao poseban unos u adData
      for (int i = 0; i < _equipmentIds.length; i++) {
        adData['EquipmentIds[$i]'] = _equipmentIds[i];
      }

      try {
        bool success = await AutomobileAdService()
            .createAutomobileAd(adData, authHeaders, _imageFiles);

        if (success) {
          print('success:::: ${success}');
          Fluttertoast.showToast(
            msg: 'Uspješno ste kreirali oglas',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.of(context).pop(); // Redirekcija na prethodnu stranicu
        } else {
          Fluttertoast.showToast(
            msg: 'Greška prilikom kreiranja oglasa',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print('Error creating ad: $e');
        Fluttertoast.showToast(
          msg: 'Greška prilikom slanja podataka',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } finally {
        setState(() {
          _isLoading = false; // Vraćanje isLoading na false nakon završetka
        });
      }
    }
  }

  // Open a modal to select equipment
  Future<void> _openEquipmentSelectionModal(BuildContext context) async {
    final selected = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Equipment'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: _equipment.map((equipment) {
                    return CheckboxListTile(
                      title: Text(equipment.name),
                      value: _equipmentIds.contains(equipment.id),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected ?? false) {
                            _equipmentIds.add(equipment.id);
                          } else {
                            _equipmentIds.remove(equipment.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(_equipmentIds); // Return selected equipment
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );

    // If the user selected something, update the equipment list
    if (selected != null) {
      setState(() {
        _equipmentIds = selected;

        // Get the names of the selected equipment
        _selectedEquipmentNames = _equipment
            .where((equipment) => _equipmentIds.contains(equipment.id))
            .map((e) => e.name)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj oglas'),
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Form Fields (Title, Description, Price, Mileage, etc.)
              TextFormField(
                decoration: InputDecoration(labelText: 'Naziv'),
                onSaved: (value) => _title = value,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite naziv' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Detaljan opis'),
                onSaved: (value) => _description = value,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite opis' : null,
                maxLines: null, // This makes the field behave like a textarea
                keyboardType:
                    TextInputType.multiline, // Allows multi-line input
                textInputAction: TextInputAction
                    .newline, // Allows new lines when pressing 'Enter'
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cijena'),
                onSaved: (value) => _price = double.tryParse(value ?? ''),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite cijenu' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Kilometraža'),
                onSaved: (value) => _mileage = int.tryParse(value ?? ''),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite kilometražu' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Godina proizvodnje'),
                onSaved: (value) =>
                    _yearOfManufacture = int.tryParse(value ?? ''),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Unesite godinu proizvodnje'
                    : null,
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Snaga motora'),
                onSaved: (value) => _enginePower = int.tryParse(value ?? ''),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite snagu motora' : null,
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Broj vrata'),
                onSaved: (value) => _numberOfDoors = int.tryParse(value ?? ''),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesi broj vrata' : null,
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Kubikaža'),
                onSaved: (value) => _cubicCapacity = int.tryParse(value ?? ''),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesi kubikažu' : null,
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Konjskih snaga'),
                onSaved: (value) => _horsePower = int.tryParse(value ?? ''),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesi konjske snage' : null,
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Boja'),
                onSaved: (value) =>
                    _color = value, // Directly save the color as a String
                validator: (value) => value?.isEmpty ?? true
                    ? 'Unesi boju'
                    : null, // Validation for empty input
                keyboardType: TextInputType.text, // Use text input for strings
              ),

              ////FIX
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Datum isteka registracije'),
                readOnly: true,
                controller: TextEditingController(
                  text: _registrationExpirationDate == null
                      ? ''
                      : '${_registrationExpirationDate!.toLocal()}'
                          .split(' ')[0],
                ),
                onTap: () => _selectDate(context, _registrationExpirationDate,
                    (pickedDate) {
                  setState(() {
                    _registrationExpirationDate = pickedDate;
                  });
                }),
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Datum malog servisa'),
                readOnly: true,
                controller: TextEditingController(
                  text: _lastSmallService == null
                      ? ''
                      : '${_lastSmallService!.toLocal()}'.split(' ')[0],
                ),
                onTap: () =>
                    _selectDate(context, _lastSmallService, (pickedDate) {
                  setState(() {
                    _lastSmallService = pickedDate;
                  });
                }),
              ),

              // Last Big Service Date Picker
              TextFormField(
                decoration: InputDecoration(labelText: 'Datum velikog servisa'),
                readOnly: true,
                controller: TextEditingController(
                  text: _lastBigService == null
                      ? ''
                      : '${_lastBigService!.toLocal()}'.split(' ')[0],
                ),
                onTap: () =>
                    _selectDate(context, _lastBigService, (pickedDate) {
                  setState(() {
                    _lastBigService = pickedDate;
                  });
                }),
              ),

              // Car Brand Dropdown with limited width and scroll
              Container(
                child: DropdownButtonFormField<String>(
                  value: _carBrandId,
                  onChanged: (value) => setState(() => _carBrandId = value),
                  items: _carBrands.map((brand) {
                    return DropdownMenuItem<String>(
                      value: brand.id.toString(),
                      child: Text(brand.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Brend'),
                  isExpanded:
                      true, // Ensures that the dropdown takes up the full width
                  menuMaxHeight:
                      300, // Limits the max height of the dropdown list
                ),
              ),

              Container(
                child: DropdownButtonFormField<String>(
                  value: _carModelId,
                  onChanged: (value) => setState(() => _carModelId = value),
                  items: _carModels.map((model) {
                    return DropdownMenuItem<String>(
                      value: model.id.toString(),
                      child: Text(model.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Model'),
                  isExpanded:
                      true, // Ensures that the dropdown takes up the full width
                  menuMaxHeight:
                      300, // Limits the max height of the dropdown list
                ),
              ),

// Car Category Dropdown with limited width and scroll
              Container(
                child: DropdownButtonFormField<String>(
                  value: _carCategoryId,
                  onChanged: (value) => setState(() => _carCategoryId = value),
                  items: _carCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(category.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Kateegorija'),
                  isExpanded:
                      true, // Ensures that the dropdown takes up the full width
                  menuMaxHeight:
                      300, // Limits the max height of the dropdown list
                ),
              ),

// Fuel Type Dropdown with limited width and scroll
              Container(
                child: DropdownButtonFormField<String>(
                  value: _fuelTypeId,
                  onChanged: (value) => setState(() => _fuelTypeId = value),
                  items: _fuelTypes.map((fuel) {
                    return DropdownMenuItem<String>(
                      value: fuel.id.toString(),
                      child: Text(fuel.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Tip goriva'),
                  isExpanded:
                      true, // Ensures that the dropdown takes up the full width
                  menuMaxHeight:
                      300, // Limits the max height of the dropdown list
                ),
              ),

// Transmission Type Dropdown with limited width and scroll
              Container(
                child: DropdownButtonFormField<String>(
                  value: _transmissionTypeId,
                  onChanged: (value) =>
                      setState(() => _transmissionTypeId = value),
                  items: _transmissionTypes.map((transmission) {
                    return DropdownMenuItem<String>(
                      value: transmission.id.toString(),
                      child: SizedBox(
                        width: 250, // Control the width of the dropdown items
                        child: Text(
                          transmission.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Tip transimisije'),
                  isExpanded:
                      true, // Ensures that the dropdown takes up the full width
                  menuMaxHeight:
                      300, // Limits the max height of the dropdown list
                ),
              ),

// Vehicle Condition Dropdown with limited width and scroll
              Container(
                child: DropdownButtonFormField<String>(
                  value: _vehicleConditionId,
                  onChanged: (value) =>
                      setState(() => _vehicleConditionId = value),
                  items: _vehicleConditions.map((condition) {
                    return DropdownMenuItem<String>(
                      value: condition.id.toString(),
                      child: Text(condition.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Stanje'),
                  isExpanded:
                      true, // Ensures that the dropdown takes up the full width
                  menuMaxHeight:
                      300, // Limits the max height of the dropdown list
                ),
              ),

              // Checkbox for 'Registered'
              CheckboxListTile(
                title: Text('Registrovan'),
                value: _isRegistered,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isRegistered = newValue ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity
                    .leading, // Align the checkbox to the left
                activeColor: Colors
                    .blue, // Change the color of the checkbox when selected
                checkColor: Colors.white, // Color for the checkmark
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _openEquipmentSelectionModal(context); // Open modal
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white, // Text color
                    side: BorderSide(
                      color: Color(
                          0xFF263238), // Blue Gray 900 color for the border
                      width: 2, // Border width
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: Text('Dodaj opremu'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _selectedEquipmentNames.isEmpty
                    ? Text('')
                    : Wrap(
                        spacing: 8.0,
                        children: _selectedEquipmentNames.map((equipment) {
                          return Chip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  equipment,
                                  style: TextStyle(
                                    color: Colors.black, // Text color black
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.check, // Checkmark icon
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ],
                            ),
                            backgroundColor:
                                Colors.white, // Background color for the chip
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: Color(
                                    0xFF263238), // Blue Gray 900 border color
                                width: 2, // Border width
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),

              SizedBox(
                height: 16.0, // You can adjust the height as needed for spacing
              ),

              ImagePickerWidget(
                onImagesPicked: (images) {
                  setState(() {
                    _imageFiles = images;
                  });
                },
              ),

              SizedBox(
                height: 16.0, // You can adjust the height as needed for spacing
              ),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _submitForm, // Onemogućeno dok traje poziv
                child: _isLoading
                    ? CircularProgressIndicator(
                        color:
                            Colors.white, // Možeš prilagoditi boju indikatora
                      )
                    : Text('Objavi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
