import 'dart:convert';

class Aprawdatamodel {
  String id;
  final String Trackingnumber;
  final String Cnee_Name;
  final String Cnee_Address;
  final String Cnee_PostalCode;
  final String Cnee_City;
  final String Cnee_Phone;
  final String AP_Number;
  final String AP_Name;
  final String AP_Address;
  final String AP_PostCode;
  String AP_City;
  Aprawdatamodel({
    required this.id,
    required this.Trackingnumber,
    required this.Cnee_Name,
    required this.Cnee_Address,
    required this.Cnee_PostalCode,
    required this.Cnee_City,
    required this.Cnee_Phone,
    required this.AP_Number,
    required this.AP_Name,
    required this.AP_Address,
    required this.AP_PostCode,
    required this.AP_City,
  });

  Aprawdatamodel copyWith({
    String? id,
    String? Trackingnumber,
    String? Cnee_Name,
    String? Cnee_Address,
    String? Cnee_PostalCode,
    String? Cnee_City,
    String? Cnee_Phone,
    String? AP_Number,
    String? AP_Name,
    String? AP_Address,
    String? AP_PostCode,
    String? AP_City,
  }) {
    return Aprawdatamodel(
      id: id ?? this.id,
      Trackingnumber: Trackingnumber ?? this.Trackingnumber,
      Cnee_Name: Cnee_Name ?? this.Cnee_Name,
      Cnee_Address: Cnee_Address ?? this.Cnee_Address,
      Cnee_PostalCode: Cnee_PostalCode ?? this.Cnee_PostalCode,
      Cnee_City: Cnee_City ?? this.Cnee_City,
      Cnee_Phone: Cnee_Phone ?? this.Cnee_Phone,
      AP_Number: AP_Number ?? this.AP_Number,
      AP_Name: AP_Name ?? this.AP_Name,
      AP_Address: AP_Address ?? this.AP_Address,
      AP_PostCode: AP_PostCode ?? this.AP_PostCode,
      AP_City: AP_City ?? this.AP_City,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Trackingnumber': Trackingnumber,
      'Cnee_Name': Cnee_Name,
      'Cnee_Address': Cnee_Address,
      'Cnee_PostalCode': Cnee_PostalCode,
      'Cnee_City': Cnee_City,
      'Cnee_Phone': Cnee_Phone,
      'AP Number': AP_Number,
      'AP Name': AP_Name,
      'AP Address': AP_Address,
      'AP PostCode': AP_PostCode,
      'AP City': AP_City,
    };
  }

  factory Aprawdatamodel.fromMap(Map<String, dynamic> map) {
    return Aprawdatamodel(
      id: map['id'],
      Trackingnumber: map['Trackingnumber'],
      Cnee_Name: map['Cnee_Name'],
      Cnee_Address: map['Cnee_Address'],
      Cnee_PostalCode: map['Cnee_PostalCode'],
      Cnee_City: map['Cnee_City'],
      Cnee_Phone: map['Cnee_Phone'],
      AP_Number: map['AP Number'],
      AP_Name: map['AP Name'],
      AP_Address: map['AP Address'],
      AP_PostCode: map['AP PostCode'],
      AP_City: map['AP City'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Aprawdatamodel.fromJson(String source) =>
      Aprawdatamodel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Aprawdatamodel(id: $id, Trackingnumber: $Trackingnumber, Cnee_Name: $Cnee_Name, Cnee_Address: $Cnee_Address, Cnee_PostalCode: $Cnee_PostalCode, Cnee_City: $Cnee_City, Cnee_Phone: $Cnee_Phone, AP Number: $AP_Number, AP Name: $AP_Name, AP Address: $AP_Address, AP PostCode: $AP_PostCode, AP City: $AP_City)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Aprawdatamodel &&
        other.id == id &&
        other.Trackingnumber == Trackingnumber &&
        other.Cnee_Name == Cnee_Name &&
        other.Cnee_Address == Cnee_Address &&
        other.Cnee_PostalCode == Cnee_PostalCode &&
        other.Cnee_City == Cnee_City &&
        other.Cnee_Phone == Cnee_Phone &&
        other.AP_Number == AP_Number &&
        other.AP_Name == AP_Name &&
        other.AP_Address == AP_Address &&
        other.AP_PostCode == AP_PostCode &&
        other.AP_City == AP_City;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        Trackingnumber.hashCode ^
        Cnee_Name.hashCode ^
        Cnee_Address.hashCode ^
        Cnee_PostalCode.hashCode ^
        Cnee_City.hashCode ^
        Cnee_Phone.hashCode ^
        AP_Number.hashCode ^
        AP_Name.hashCode ^
        AP_Address.hashCode ^
        AP_PostCode.hashCode ^
        AP_City.hashCode;
  }
}
