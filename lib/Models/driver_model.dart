// @dart=2.9
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Driver_Model {
  String id;
  String name;
  String email;
  String number;
  String photo;
  String role;
  String route;
  Driver_Model({
    @required this.id,
    this.name,
    this.email,
    this.number,
    this.photo,
    this.role,
    @required this.route,
  });

  Driver_Model copyWith({
    String id,
    String name,
    String email,
    String number,
    String photo,
    String role,
    String route,
  }) {
    return Driver_Model(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      number: number ?? this.number,
      photo: photo ?? this.photo,
      role: role ?? this.role,
      route: route ?? this.route,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Driver_Name': name,
      'Email': email,
      'Phone_Number': number,
      'Photo': photo,
      'Role': role,
      'Route': route,
    };
  }

  factory Driver_Model.fromMap(Map<String, dynamic> map) {
    return Driver_Model(
      id: map['id'],
      name: map['Driver_Name'],
      email: map['Email'],
      number: map['Phone_Number'],
      photo: map['Photo'],
      role: map['Role'],
      route: map['Route'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Driver_Model.fromJson(String source) =>
      Driver_Model.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Driver_Model(id: $id, Driver_Name: $name, Email: $email, Phone_Number: $number, Photo: $photo, Role: $role, Route: $route)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Driver_Model &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.number == number &&
        other.photo == photo &&
        other.role == role &&
        other.route == route;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        number.hashCode ^
        photo.hashCode ^
        role.hashCode ^
        route.hashCode;
  }
}
