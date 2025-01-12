import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vroom_app/components/ImagePicker.dart';
import 'package:vroom_app/components/shared/DatePicker.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';
import 'package:vroom_app/services/AutmobileDropDownService.dart';
import 'package:vroom_app/services/AutomobileAdService.dart';
import 'package:vroom_app/models/carBrand.dart';
import 'package:vroom_app/models/carCategory.dart';
import 'package:vroom_app/models/carModel.dart';
import 'package:vroom_app/models/fuelType.dart';
import 'package:vroom_app/models/transmissionType.dart';
import 'package:vroom_app/models/vehicleCondition.dart';

import '../models/equipment.dart';
import '../services/AuthService.dart';

class AddAutomobileScreen extends StatefulWidget {
  const AddAutomobileScreen({Key? key}) : super(key: key);

  @override
  _AddAutomobileScreenState createState() => _AddAutomobileScreenState();
}

class _AddAutomobileScreenState extends State<AddAutomobileScreen> {
  bool _isLoading = false;
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
  final AutomobileDropDownService _dropDownService =
      AutomobileDropDownService();

  Future<void> _fetchAutomobileDropDownData() async {
    try {
      final carBrands = await _dropDownService.fetchCarBrands();
      final carCategories = await _dropDownService.fetchCarCategories();
      final carModels = await _dropDownService.fetchCarModels();
      final fuelTypes = await _dropDownService.fetchFuelTypes();
      final transmissionTypes = await _dropDownService.fetchTransmissionTypes();
      final vehicleConditions = await _dropDownService.fetchVehicleConditions();
      final equipments = await _dropDownService.fetchEquipments();

      setState(() {
        _carBrands = carBrands;
        _carCategories = carCategories;
        _carModels = carModels;
        _fuelTypes = fuelTypes;
        _transmissionTypes = transmissionTypes;
        _vehicleConditions = vehicleConditions;
        _equipment = equipments;
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
        'Milage': _mileage,
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
          ToastUtils.showToast(message: "Uspješno ste kreirali oglas");

          Navigator.of(context).pop(); // Redirekcija na prethodnu stranicu
        } else {
          ToastUtils.showErrorToast(
              message: "Greška prilikom kreiranja oglasa:");
        }
      } catch (e) {
        print('Error creating ad: $e');
        ToastUtils.showErrorToast(message: "Greška prilikom kreiranja oglasa:");
      } finally {
        setState(() {
          _isLoading = false;
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
          title: Text('Odaberi opremu'),
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
              child: Text('Završi'),
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
                    _color = value, // Directly save the color as a StringR
                keyboardType: TextInputType.text, // Use text input for strings
              ),

              Column(
                children: [
                  DatePicker(
                    label: 'Datum isteka registracije',
                    selectedDate: _registrationExpirationDate,
                    onDatePicked: (pickedDate) {
                      setState(() {
                        _registrationExpirationDate = pickedDate;
                      });
                    },
                  ),
                  DatePicker(
                    label: 'Datum malog servisa',
                    selectedDate: _lastSmallService,
                    onDatePicked: (pickedDate) {
                      setState(() {
                        _lastSmallService = pickedDate;
                      });
                    },
                  ),
                  DatePicker(
                    label: 'Datum velikog servisa',
                    selectedDate: _lastBigService,
                    onDatePicked: (pickedDate) {
                      setState(() {
                        _lastBigService = pickedDate;
                      });
                    },
                  ),
                ],
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
                  menuMaxHeight: 300,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Obavezno polje'; // Poruka greške ako nije odabrano
                    }
                    return null; // Ako je validno, vraća null
                  },
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
                  menuMaxHeight: 300,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Obavezno polje'; // Poruka greške ako nije odabrano
                    }
                    return null; // Ako je validno, vraća null
                  },
                ),
              ),

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
                  menuMaxHeight: 300,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Obavezno polje'; // Poruka greške ako nije odabrano
                    }
                    return null; // Ako je validno, vraća null
                  },
                ),
              ),

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
                  menuMaxHeight: 300,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Obavezno polje'; // Poruka greške ako nije odabrano
                    }
                    return null; // Ako je validno, vraća null
                  },
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
                  menuMaxHeight: 300,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Obavezno polje'; // Poruka greške ako nije odabrano
                    }
                    return null; // Ako je validno, vraća null
                  },
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
                  menuMaxHeight: 300,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Obavezno polje'; // Poruka greške ako nije odabrano
                    }
                    return null; // Ako je validno, vraća null
                  },
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
                    side: const BorderSide(
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
                                const Icon(
                                  Icons.check, // Checkmark icon
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ],
                            ),
                            backgroundColor:
                                Colors.white, // Background color for the chip
                            shape: const StadiumBorder(
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

              const SizedBox(
                height: 16.0, // You can adjust the height as needed for spacing
              ),

              ImagePickerWidget(
                onImagesPicked: (images) {
                  setState(() {
                    _imageFiles = images;
                  });
                },
              ),

              const SizedBox(
                height: 16.0,
              ),

              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _submitForm, // Onemogućeno dok traje poziv
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white, // Pozadina dugmeta
                  side: BorderSide(
                    color: Color(0xFF263238), // Blue Gray 900 border
                    width: 2, // Debljina okvira
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Zaobljeni uglovi dugmeta
                  ),
                  elevation: 0, // Nema senke za dugme
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20, // Manja veličina indikatora
                        height: 20,
                        child: const CircularProgressIndicator(
                          color: Colors.blueGrey, // Plava boja indikatora
                          strokeWidth: 2, // Manja debljina indikatora
                        ),
                      )
                    : const Text(
                        'Objavi',
                        style: TextStyle(
                            color: Colors.black), // Crni tekst dugmeta
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
