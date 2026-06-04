import 'package:cloud_firestore/cloud_firestore.dart';

class FuelEntry {
  String? id;
  String? vehicleId;
  DateTime? date;
  double? liters;
  double? amount;

  FuelEntry({this.id, this.vehicleId, this.date, this.liters, this.amount});

  FuelEntry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicleId'];
    date = (json['date'] as Timestamp?)?.toDate();
    liters = json['liters']?.toDouble();
    amount = json['amount']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'liters': liters,
      'amount': amount,
    };
  }
}
