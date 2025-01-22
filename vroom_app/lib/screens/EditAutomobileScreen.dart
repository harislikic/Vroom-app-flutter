import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';
import 'package:vroom_app/models/automobileAd.dart';
import 'package:vroom_app/services/ApiConfig.dart';
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
  final List<XFile> _newImages = [];

  bool _isFormChanged = false;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _mileageController;
  late TextEditingController _yearOfManufactureController;
  late TextEditingController _enginePowerController;
  late TextEditingController _numberOfDoorsController;
  late TextEditingController _cubicCapacityController;
  late TextEditingController _horsePowerController;
  late TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.automobileAd.title);
    _descriptionController =
        TextEditingController(text: widget.automobileAd.description);
    _priceController =
        TextEditingController(text: widget.automobileAd.price.toString());
    _mileageController =
        TextEditingController(text: widget.automobileAd.mileage.toString());
    _yearOfManufactureController = TextEditingController(
        text: widget.automobileAd.yearOfManufacture.toString());
    _enginePowerController =
        TextEditingController(text: widget.automobileAd.enginePower.toString());
    _numberOfDoorsController = TextEditingController(
        text: widget.automobileAd.numberOfDoors.toString());
    _cubicCapacityController = TextEditingController(
        text: widget.automobileAd.cubicCapacity.toString());
    _horsePowerController =
        TextEditingController(text: widget.automobileAd.horsePower.toString());
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
      case 'yearOfManufacture':
        return widget.automobileAd.yearOfManufacture;
      case 'enginePower':
        return widget.automobileAd.enginePower;
      case 'numberOfDoors':
        return widget.automobileAd.numberOfDoors;
      case 'cubicCapacity':
        return widget.automobileAd.cubicCapacity;
      case 'horsePower':
        return widget.automobileAd.horsePower;
      case 'color':
        return widget.automobileAd.color;
      default:
        return null;
    }
  }

  void _removeImage(int imageId) {
    setState(() {
      _removedImageIds.add(imageId);
      widget.automobileAd.images.removeWhere((image) => image.id == imageId);
    });
  }

  Future<void> _pickNewImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _newImages.addAll(pickedImages);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_updatedFields.isNotEmpty ||
          _removedImageIds.isNotEmpty ||
          _newImages.isNotEmpty) {
        final automobileAdService = AutomobileAdService();

        // Attempt to update the automobile ad with the updated fields, new images, and removed image IDs
        final success = await automobileAdService.updateAutomobileAd(
          widget.automobileAd.id,
          _updatedFields,
          newImages: _newImages,
          removedImageIds: _removedImageIds,
        );

        if (success) {
          ToastUtils.showToast(message: 'Uspjesno editovano');
        } else {
          ToastUtils.showToast(message: 'Greska prilikom editovanja');
        }
      } else {
        ToastUtils.showToast(message: 'Nije napravljena izmjena');
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
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Detaljan opis'),
                onChanged: (value) => _trackChanges('description', value),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite opis' : null,
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
                onChanged: (value) =>
                    _trackChanges('mileage', int.tryParse(value) ?? 0),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite kilometražu' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _yearOfManufactureController,
                decoration:
                    const InputDecoration(labelText: 'Godina proizvodnje'),
                onChanged: (value) => _trackChanges(
                    'yearOfManufacture', int.tryParse(value) ?? 0),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Unesite godinu proizvodnje'
                    : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _enginePowerController,
                decoration: const InputDecoration(labelText: 'Snaga motora'),
                onChanged: (value) =>
                    _trackChanges('enginePower', int.tryParse(value) ?? 0),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite snagu motora' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _numberOfDoorsController,
                decoration: const InputDecoration(labelText: 'Broj vrata'),
                onChanged: (value) =>
                    _trackChanges('numberOfDoors', int.tryParse(value) ?? 0),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite broj vrata' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _cubicCapacityController,
                decoration: const InputDecoration(labelText: 'Kubikaža'),
                onChanged: (value) =>
                    _trackChanges('cubicCapacity', int.tryParse(value) ?? 0),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite kubikažu' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _horsePowerController,
                decoration: const InputDecoration(labelText: 'Konjskih snaga'),
                onChanged: (value) =>
                    _trackChanges('horsePower', int.tryParse(value) ?? 0),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Unesite konjske snage' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Boja'),
                onChanged: (value) => _trackChanges('color', value),
              ),
              const SizedBox(height: 16.0),
              const Text('Slike:'),
              Wrap(
                spacing: 8.0,
                children: [
                  for (var image in widget.automobileAd.images)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${ApiConfig.baseUrl}${image.imageUrl}',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () => _removeImage(image.id),
                          ),
                        ),
                      ],
                    ),
                  for (var newImage in _newImages)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(newImage.path),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _newImages.remove(newImage);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                ],
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
