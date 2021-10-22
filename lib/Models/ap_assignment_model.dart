import 'dart:convert';

class ApAssignment {
  String id;
  String name;
  String address;
  String awb;
  bool pending;
  ApAssignment({
    required this.id,
    required this.name,
    required this.address,
    required this.awb,
    required this.pending,
  });

  ApAssignment copyWith({
    String? id,
    String? name,
    String? address,
    String? awb,
    bool? pending,
  }) {
    return ApAssignment(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      awb: awb ?? this.awb,
      pending: pending ?? this.pending,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
      'Address': address,
      'Awb': awb,
      'Pending': pending,
    };
  }

  factory ApAssignment.fromMap(Map<String, dynamic> map) {
    return ApAssignment(
      id: map['Id'],
      name: map['Name'],
      address: map['Address'],
      awb: map['Awb'],
      pending: map['Pending'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApAssignment.fromJson(String source) =>
      ApAssignment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ApAssignment(Id: $id, Name: $name, Address: $address, Awb: $awb, Pending: $pending)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApAssignment &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.awb == awb &&
        other.pending == pending;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        awb.hashCode ^
        pending.hashCode;
  }
}
