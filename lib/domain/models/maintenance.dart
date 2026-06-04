import 'package:cloud_firestore/cloud_firestore.dart';

class Maintenance {
  String? id;
  String? vehicleId;
  String? categoryId;
  String? categoryName;
  String? description;
  DateTime? date;
  double? cost;

  Maintenance({
    this.id,
    this.vehicleId,
    this.categoryId,
    this.categoryName,
    this.description,
    this.date,
    this.cost,
  });

  Maintenance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicleId'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    description = json['description'];
    date = (json['date'] as Timestamp?)?.toDate();
    cost = json['cost']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'cost': cost,
    };
  }
}
