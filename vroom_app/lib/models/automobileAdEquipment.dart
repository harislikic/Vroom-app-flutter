import 'equipment.dart';

class AutomobileAdEquipment {
  final Equipment equipment;

  AutomobileAdEquipment({
    required this.equipment,
  });

  factory AutomobileAdEquipment.fromJson(Map<String, dynamic> json) {
    return AutomobileAdEquipment(
      equipment: Equipment.fromJson(json['equipment']),
    );
  }
}
