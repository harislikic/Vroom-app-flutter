import 'package:vroom_app/models/carBrand.dart';
import 'package:vroom_app/models/carCategory.dart';
import 'package:vroom_app/models/carModel.dart';
import 'package:vroom_app/models/city.dart';
import 'package:vroom_app/models/equipment.dart';
import 'package:vroom_app/models/fuelType.dart';
import 'package:vroom_app/models/transmissionType.dart';
import 'package:vroom_app/models/vehicleCondition.dart';
import 'package:vroom_app/services/CarBrandService.dart';
import 'package:vroom_app/services/CarCategoryService.dart';
import 'package:vroom_app/services/CarModelService.dart';
import 'package:vroom_app/services/CityService.dart';
import 'package:vroom_app/services/EquipemntService.dart';
import 'package:vroom_app/services/FuelTypeService.dart';
import 'package:vroom_app/services/TransmissionTypeService.dart';
import 'package:vroom_app/services/VehicleConditionService.dart';

class AutomobileDropDownService {
  final CarBrandService _carBrandService = CarBrandService();
  final CarCategoryService _carCategoryService = CarCategoryService();
  final CarModelService _carModelService = CarModelService();
  final FuelTypeService _fuelTypeService = FuelTypeService();
  final TransmissionTypeService _transmissionTypeService =
      TransmissionTypeService();
  final VehicleConditionService _vehicleConditionService =
      VehicleConditionService();
  final EquipmentService _equipmentService = EquipmentService();
  final CityService _cityService = CityService();

  Future<List<CarBrand>> fetchCarBrands() async {
    return await _carBrandService.fetchCarBrands();
  }

  Future<List<CarCategory>> fetchCarCategories() async {
    return await _carCategoryService.fetchCarCategories();
  }

  Future<List<CarModel>> fetchCarModels() async {
    return await _carModelService.fetchCarModels();
  }

  Future<List<FuelType>> fetchFuelTypes() async {
    return await _fuelTypeService.fetchFuelTypes();
  }

  Future<List<TransmissionType>> fetchTransmissionTypes() async {
    return await _transmissionTypeService.fetchTransmissionTypes();
  }

  Future<List<VehicleCondition>> fetchVehicleConditions() async {
    return await _vehicleConditionService.fetchVehicleConditions();
  }

  Future<List<Equipment>> fetchEquipments() async {
    return await _equipmentService.fetchEquipments();
  }

  Future<List<City>> fetchCities() async {
    return await _cityService.fetchCities();
  }
}
