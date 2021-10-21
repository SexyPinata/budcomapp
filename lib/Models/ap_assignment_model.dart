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
      'id': id,
      'name': name,
      'address': address,
      'awb': awb,
      'pending': pending,
    };
  }

  factory ApAssignment.fromMap(Map<String, dynamic> map) {
    return ApAssignment(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      awb: map['awb'],
      pending: map['pending'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApAssignment.fromJson(String source) =>
      ApAssignment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ApAssignment(id: $id, name: $name, address: $address, awb: $awb, pending: $pending)';
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
