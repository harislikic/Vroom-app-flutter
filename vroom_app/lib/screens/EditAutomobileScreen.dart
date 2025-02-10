import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vroom_app/components/ImageGalleryEditAutomobile.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';
import 'package:vroom_app/models/automobileAd.dart';
import 'package:vroom_app/models/equipment.dart';
import 'package:vroom_app/screens/MyAutomobileAdsScreen.dart';
import 'package:vroom_app/services/AutmobileDropDownService.dart';
import 'package:vroom_app/services/AutomobileAdService.dart';

class EditAutomobileScreen extends StatefulWidget {
  final AutomobileAd automobileAd;

  const EditAutomobileScreen({Key? key, required this.automobileAd})
      : super(key: key);

  @override
  _EditAutomobileScreenState createState() => _EditAutomobileScreenState();
}

class _EditAutomobileScreenState extends State<EditAutomobileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _updatedFields = {};
  final List<int> _removedImageIds = [];
  final List<int> _removedEquipmentIds =
      []; // Nova lista za praćenje uklonjene opreme
  final List<XFile> _newImages = [];
  bool _isFormChanged = false;
  
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _mileageController;
  late TextEditingController _colorController;

  List<int> _selectedEquipmentIds = [];
  List<String> _selectedEquipmentNames = [];
  List<Equipment> _allEquipments = [];
  List<int> _originalEquipmentIds = [];

  final AutomobileDropDownService _dropDownService =
      AutomobileDropDownService();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeSelectedEquipment();
    _fetchEquipments();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.automobileAd.title);
    _descriptionController =
        TextEditingController(text: widget.automobileAd.description);
    _priceController =
        TextEditingController(text: widget.automobileAd.price.toString());
    _mileageController =
        TextEditingController(text: widget.automobileAd.mileage.toString());
    _colorController = TextEditingController(text: widget.automobileAd.color);
  }

  void _trackChanges(String field, dynamic newValue) {
    final originalValue = _getOriginalValue(field);
    setState(() {
      if (originalValue != newValue) {
        _updatedFields[field] = newValue;
        _isFormChanged = true;
      } else {
        _updatedFields.remove(field);
        _isFormChanged = _updatedFields.isNotEmpty ||
            _removedImageIds.isNotEmpty ||
            _newImages.isNotEmpty;
      }
    });
  }

  dynamic _getOriginalValue(String field) {
    switch (field) {
      case 'title':
        return widget.automobileAd.title;
      case 'description':
        return widget.automobileAd.description;
      case 'price':
        return widget.automobileAd.price;
      case 'mileage':
        return widget.automobileAd.mileage;
      case 'color':
        return widget.automobileAd.color;
      default:
        return null;
    }
  }

  void _initializeSelectedEquipment() {
    _selectedEquipmentIds = widget.automobileAd.automobileAdEquipments
        .map((ae) => ae.equipment.id)
        .toList();
    _selectedEquipmentNames = widget.automobileAd.automobileAdEquipments
        .map((ae) => ae.equipment.name)
        .toList();
    _originalEquipmentIds = List<int>.from(_selectedEquipmentIds);
  }

  Future<void> _fetchEquipments() async {
    try {
      final equipments = await _dropDownService.fetchEquipments();
      setState(() {
        _allEquipments = equipments;
      });
    } catch (e) {
      ToastUtils.showErrorToast(message: 'Greška pri učitavanju opreme.');
    }
  }

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
                  children: _allEquipments.map((equipment) {
                    return CheckboxListTile(
                      title: Text(equipment.name),
                      value: _selectedEquipmentIds.contains(equipment.id),
                      onChanged: (bool? isChecked) {
                        setState(() {
                          if (isChecked ?? false) {
                            if (!_selectedEquipmentIds.contains(equipment.id)) {
                              _selectedEquipmentIds.add(equipment.id);
                            }
                          } else {
                            if (_selectedEquipmentIds.contains(equipment.id)) {
                              _selectedEquipmentIds.remove(equipment.id);
                              if (_originalEquipmentIds
                                  .contains(equipment.id)) {
                                _removedEquipmentIds
                                    .add(equipment.id); // Dodaj u uklonjene
                              }
                            }
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
                Navigator.of(context).pop(_selectedEquipmentIds);
              },
              child: Text('Završi'),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedEquipmentIds = selected;
        _selectedEquipmentNames = _allEquipments
            .where((equipment) => _selectedEquipmentIds.contains(equipment.id))
            .map((e) => e.name)
            .toList();
        _isFormChanged = true;
      });
    }
  }

  void _removeImage(int imageId) {
    setState(() {
      _removedImageIds.add(imageId);
      widget.automobileAd.images.removeWhere((image) => image.id == imageId);
      _isFormChanged = true;
    });
  }

  Future<void> _pickNewImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _newImages.addAll(pickedImages);
        _isFormChanged = true;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final bool equipmentChanged = !const ListEquality()
          .equals(_originalEquipmentIds, _selectedEquipmentIds);

      if (_updatedFields.isNotEmpty ||
          _removedImageIds.isNotEmpty ||
          _newImages.isNotEmpty ||
          equipmentChanged ||
          _removedEquipmentIds.isNotEmpty) {
        final automobileAdService = AutomobileAdService();

        // Ažuriraj novu opremu
        if (equipmentChanged) {
          _updatedFields['EquipmentIds'] = _selectedEquipmentIds;
        }

        // Ukloni postojeću opremu
        if (_removedEquipmentIds.isNotEmpty) {
          final deleteSuccess =
              await automobileAdService.deleteAutomobileEquipment(
            widget.automobileAd.id,
            _removedEquipmentIds,
          );
          if (!deleteSuccess) {
            ToastUtils.showErrorToast(
                message: 'Greška prilikom brisanja opreme.');
            return;
          }
        }

        // Ažuriraj oglas
        final success = await automobileAdService.updateAutomobileAd(
          widget.automobileAd.id,
          _updatedFields,
          newImages: _newImages,
          removedImageIds: _removedImageIds,
        );

        if (success) {
          ToastUtils.showToast(message: 'Uspješno editovano');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyAutomobileAdsScreen()),
          );
        } else {
          ToastUtils.showErrorToast(message: 'Greška prilikom editovanja');
        }
      } else {
        ToastUtils.showToast(message: 'Nema promjena za čuvanje');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uredi oglas'),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Naziv'),
                onChanged: (value) => _trackChanges('title', value),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite naziv' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Cijena'),
                onChanged: (value) =>
                    _trackChanges('price', double.tryParse(value) ?? 0),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite cijenu' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Kilometraža'),
                onChanged: (value) {
                  final intValue = double.tryParse(value)?.toInt() ?? 0;
                  _trackChanges('milage', intValue);
                },
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite kilometražu' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Boja'),
                onChanged: (value) => _trackChanges('color', value),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Detaljan opis',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _trackChanges('description', value),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite opis' : null,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              Text('Dodatna oprema:',
                  style: Theme.of(context).textTheme.subtitle1),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: _selectedEquipmentNames.map((equipment) {
                  return Chip(
                    label: Text(equipment),
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(
                      side: BorderSide(
                        color: Color(0xFF263238),
                        width: 2,
                      ),
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () => _openEquipmentSelectionModal(context),
                child: const Text('Uredi opremu'),
              ),
              const SizedBox(height: 16.0),
              ImageGalleryEditAutomobile(
                existingImages: widget.automobileAd.images,
                newImages: _newImages,
                onRemoveExistingImage: (imageId) => _removeImage(imageId),
                onRemoveNewImage: (newImage) {
                  setState(() {
                    _newImages.remove(newImage);
                    _isFormChanged = true;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _pickNewImages,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blueGrey[900]!),
                  textStyle: const TextStyle(color: Colors.black),
                ),
                child: const Text('Dodaj nove slike',
                    style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: _isFormChanged ? _submitForm : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blueGrey[900]!),
                  textStyle: const TextStyle(color: Colors.black),
                ),
                child: const Text('Spremi promjene',
                    style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
