import 'dart:convert';

class Aprawdatamodel {
  final String id;
  final String Tracking_Number;
  final String Receiver_Name;
  final String Street;
  final int Areacode;
  final String City;
  final String Receiver_Phone;
  final String Access_Point_Name;
  final String Access_Point_Street;
  final int Access_Point_Areacode;
  final String Access_Point_City;
  Aprawdatamodel({
    required this.id,
    required this.Tracking_Number,
    required this.Receiver_Name,
    required this.Street,
    required this.Areacode,
    required this.City,
    required this.Receiver_Phone,
    required this.Access_Point_Name,
    required this.Access_Point_Street,
    required this.Access_Point_Areacode,
    required this.Access_Point_City,
  });

  Aprawdatamodel copyWith({
    String? id,
    String? Tracking_Number,
    String? Receiver_Name,
    String? Street,
    int? Areacode,
    String? City,
    String? Receiver_Phone,
    String? Access_Point_Name,
    String? Access_Point_Street,
    int? Access_Point_Areacode,
    String? Access_Point_City,
  }) {
    return Aprawdatamodel(
      id: id ?? this.id,
      Tracking_Number: Tracking_Number ?? this.Tracking_Number,
      Receiver_Name: Receiver_Name ?? this.Receiver_Name,
      Street: Street ?? this.Street,
      Areacode: Areacode ?? this.Areacode,
      City: City ?? this.City,
      Receiver_Phone: Receiver_Phone ?? this.Receiver_Phone,
      Access_Point_Name: Access_Point_Name ?? this.Access_Point_Name,
      Access_Point_Street: Access_Point_Street ?? this.Access_Point_Street,
      Access_Point_Areacode:
          Access_Point_Areacode ?? this.Access_Point_Areacode,
      Access_Point_City: Access_Point_City ?? this.Access_Point_City,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Tracking_Number': Tracking_Number,
      'Receiver_Name': Receiver_Name,
      'Street': Street,
      'Areacode': Areacode,
      'City': City,
      'Receiver_Phone': Receiver_Phone,
      'Access_Point_Name': Access_Point_Name,
      'Access_Point_Street': Access_Point_Street,
      'Access_Point_Areacode': Access_Point_Areacode,
      'Access_Point_City': Access_Point_City,
    };
  }

  factory Aprawdatamodel.fromMap(Map<String, dynamic> map) {
    return Aprawdatamodel(
      id: map['id'],
      Tracking_Number: map['Tracking_Number'],
      Receiver_Name: map['Receiver_Name'],
      Street: map['Street'],
      Areacode: map['Areacode'],
      City: map['City'],
      Receiver_Phone: map['Receiver_Phone'],
      Access_Point_Name: map['Access_Point_Name'],
      Access_Point_Street: map['Access_Point_Street'],
      Access_Point_Areacode: map['Access_Point_Areacode'],
      Access_Point_City: map['Access_Point_City'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Aprawdatamodel.fromJson(String source) =>
      Aprawdatamodel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Aprawdatamodel(id: $id, Tracking_Number: $Tracking_Number, Receiver_Name: $Receiver_Name, Street: $Street, Areacode: $Areacode, City: $City, Receiver_Phone: $Receiver_Phone, Access_Point_Name: $Access_Point_Name, Access_Point_Street: $Access_Point_Street, Access_Point_Areacode: $Access_Point_Areacode, Access_Point_City: $Access_Point_City)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Aprawdatamodel &&
        other.id == id &&
        other.Tracking_Number == Tracking_Number &&
        other.Receiver_Name == Receiver_Name &&
        other.Street == Street &&
        other.Areacode == Areacode &&
        other.City == City &&
        other.Receiver_Phone == Receiver_Phone &&
        other.Access_Point_Name == Access_Point_Name &&
        other.Access_Point_Street == Access_Point_Street &&
        other.Access_Point_Areacode == Access_Point_Areacode &&
        other.Access_Point_City == Access_Point_City;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        Tracking_Number.hashCode ^
        Receiver_Name.hashCode ^
        Street.hashCode ^
        Areacode.hashCode ^
        City.hashCode ^
        Receiver_Phone.hashCode ^
        Access_Point_Name.hashCode ^
        Access_Point_Street.hashCode ^
        Access_Point_Areacode.hashCode ^
        Access_Point_City.hashCode;
  }
}
