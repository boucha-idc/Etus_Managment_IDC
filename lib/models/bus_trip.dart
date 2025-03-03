import 'package:idc_etus_bechar/models/bus.dart';
import 'package:idc_etus_bechar/models/line.dart';
import 'package:idc_etus_bechar/models/user.dart';

class BusTrip {
  final int id;
  final int amount;
  final int currentIndex;
  final int lastIndex;
  final int lineId;
  final int busId;
  final String? startDate; // Nullable if optional
  final String? endDate; // Nullable if optional
  final int accountantId;
  final int driverId;
  final int receiverId;
  final String? observation; // Nullable if optional
  final String? createdAt; // Nullable if optional
  final String? updatedAt; // Nullable if optional
  final Bus bus;
  final User accountant;
  final BusLine line;
  final User driver;
  final User receiver;

  BusTrip({
    required this.id,
    required this.amount,
    required this.currentIndex,
    required this.lastIndex,
    required this.lineId,
    required this.busId,
    this.startDate,
    this.endDate,
    required this.accountantId,
    required this.driverId,
    required this.receiverId,
    this.observation,
    this.createdAt,
    this.updatedAt,
    required this.bus,
    required this.accountant,
    required this.line,
    required this.driver,
    required this.receiver,
  });

  factory BusTrip.fromJson(Map<String, dynamic> json) {
    try {
      return BusTrip(
        id: json['id'],
        amount: json['amount'],
        currentIndex: json['current_index'],
        lastIndex: json['last_index'],
        lineId: json['line_id'],
        busId: json['bus_id'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        accountantId: json['accountant_id'],
        driverId: json['driver_id'],
        receiverId: json['receiver_id'],
        observation: json['observation'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        bus: Bus.fromJson(json['bus']),
        accountant: User.fromJson(json['accountant']),
        line: BusLine.fromJson(json['line']),
        driver: User.fromJson(json['driver']),
        receiver: User.fromJson(json['receiver']),
      );
    } catch (e) {
      throw Exception('Error parsing BusTrip: $e');
    }
  }

  @override
  String toString() {
    return 'BusTrip(busId: $busId, busAmount:$amount, plateNumber: ${bus.plateNumber},accountntName: ${accountant.name},  driverName: ${driver.name}, receiverName: ${receiver.name}, '
        'startDate: $startDate, endDate: $endDate),UpdatedAt:${updatedAt}';
  }

  // Example of a custom method
  Duration? tripDuration() {
    if (startDate != null && endDate != null) {
      DateTime start = DateTime.parse(startDate!);
      DateTime end = DateTime.parse(endDate!);
      return end.difference(start);
    }
    return null;
  }
}
