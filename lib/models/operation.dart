import 'dart:convert';

class Operation {
  int typeId;
  int quantity;
  String observation;
  int busId;
  String unit;
  List<int> employeeIds;


  Operation({
    required this.typeId,
    required this.quantity,
    required this.observation,
    required this.busId,
    required this.unit,
    required this.employeeIds,
  });


  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      typeId: json['type_id'],
      quantity: json['quantity'],
      observation: json['observation'],
      busId: json['bus_id'],
      unit: json['unit'],
      employeeIds: List<int>.from(json['employee_ids']),
    );
  }

  // Convert Operation object to JSON
  Map<String, dynamic> toJson() {
    return {
      'type_id': typeId,
      'quantity': quantity,
      'observation': observation,
      'bus_id': busId,
      'unit': unit,
      'employee_ids': employeeIds,
    };
  }

  // Optional: Method to display Operation info as a string (for debugging purposes)
  @override
  String toString() {
    return 'Operation(typeId: $typeId, quantity: $quantity, observation: $observation, busId: $busId, unit: $unit, employeeIds: $employeeIds)';
  }
}
