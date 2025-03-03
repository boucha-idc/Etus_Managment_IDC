import 'dart:convert';

class Bus {
  final int id;
  String? qrCode;
  String? name;
  String? description;
  final String plateNumber;
  final String enteringDate;
  final String status;
  final int nextOilChangeInKm;
  String nextOilChangeDate;

  Bus({
    this.id = 0,
    this.plateNumber = '',
    this.qrCode = '',
    this.name = '',
    this.description = '',
    this.enteringDate = '',
    this.status = '',
    this.nextOilChangeInKm=0,
    this.nextOilChangeDate='',
  });

  // Method to create Bus from JSON
  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      plateNumber: json['plate_number'],
      qrCode: json['qr_code'],
      name: json['name'],
      description: json['description'],
      enteringDate: json['entering_date'],
      status: json['status'],
      nextOilChangeInKm: json['next_oil_change_in_km'],
      nextOilChangeDate: json['next_oil_change_date'],
    );
  }
}
