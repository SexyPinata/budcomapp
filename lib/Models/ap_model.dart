import 'dart:convert';

class ApModel {
  String id;
  String name;
  String city;
  String street;
  String zip;

  ApModel({
    required this.id,
    required this.name,
    required this.city,
    required this.street,
    required this.zip,
  });

  ApModel copyWith({
    String? id,
    String? name,
    String? city,
    String? street,
    String? zip,
  }) {
    return ApModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      street: street ?? this.street,
      zip: zip ?? this.zip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'street': street,
      'zip': zip,
    };
  }

  factory ApModel.fromMap(Map<String, dynamic> map) {
    return ApModel(
      id: map['id'],
      name: map['name'],
      city: map['city'],
      street: map['street'],
      zip: map['zip'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApModel.fromJson(String source) =>
      ApModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ApModel(id: $id, name: $name, city: $city, street: $street, zip: $zip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApModel &&
        other.id == id &&
        other.name == name &&
        other.city == city &&
        other.street == street &&
        other.zip == zip;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        city.hashCode ^
        street.hashCode ^
        zip.hashCode;
  }
}
