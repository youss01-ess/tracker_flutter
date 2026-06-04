class Vehicle {
  String? id;
  String? name;
  String? brand;
  String? plate;

  Vehicle({this.id, this.name, this.brand, this.plate});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    brand = json['brand'];
    plate = json['plate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'plate': plate,
    };
  }
}
