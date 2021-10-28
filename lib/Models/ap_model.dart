import 'dart:convert';

class ApModel {
  String id;
  String name;
  String city;
  String street;
  String zip;
  String number;

  ApModel(
      {required this.id,
      required this.name,
      required this.city,
      required this.street,
      required this.zip,
      required this.number});

  ApModel copyWith({
    String? id,
    String? name,
    String? city,
    String? street,
    String? zip,
    String? number,
  }) {
    return ApModel(
        id: id ?? this.id,
        name: name ?? this.name,
        city: city ?? this.city,
        street: street ?? this.street,
        zip: zip ?? this.zip,
        number: number ?? this.number);
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
      'City': city,
      'Street': street,
      'Zip': zip,
      'Number': number,
    };
  }

  factory ApModel.fromMap(Map<String, dynamic> map) {
    return ApModel(
        id: map['Id'],
        name: map['Name'],
        city: map['City'],
        street: map['Street'],
        zip: map['Zip'],
        number: map['Number']);
  }

  String toJson() => json.encode(toMap());

  factory ApModel.fromJson(String source) =>
      ApModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ApModel(Id: $id, Name: $name, City: $city, Street: $street, Zip: $zip, Number: $number)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApModel &&
        other.id == id &&
        other.name == name &&
        other.city == city &&
        other.street == street &&
        other.zip == zip &&
        other.number == number;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        city.hashCode ^
        street.hashCode ^
        zip.hashCode ^
        number.hashCode;
  }
}

class ApModelMini {
  String id;
  String name;

  ApModelMini({
    required this.id,
    required this.name,
  });

  ApModelMini copyWith({
    String? id,
    String? name,
  }) {
    return ApModelMini(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
    };
  }

  factory ApModelMini.fromMap(Map<String, dynamic> map) {
    return ApModelMini(
      id: map['Id'],
      name: map['Name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApModelMini.fromJson(String source) =>
      ApModelMini.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ApModel(Id: $id, Name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode;
  }
}
