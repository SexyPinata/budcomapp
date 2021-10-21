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
      'Id': id,
      'Name': name,
      'City': city,
      'Street': street,
      'Zip': zip,
    };
  }

  factory ApModel.fromMap(Map<String, dynamic> map) {
    return ApModel(
      id: map['Id'],
      name: map['Name'],
      city: map['City'],
      street: map['Street'],
      zip: map['Zip'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApModel.fromJson(String source) =>
      ApModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ApModel(Id: $id, Name: $name, City: $city, Street: $street, Zip: $zip)';
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
