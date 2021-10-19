import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Driver_Model {
  String name;
  String email;
  String number;
  String photo;
  String role;
  DocumentReference route;

  Driver_Model(
      {required this.name,
      required this.email,
      required this.number,
      required this.photo,
      required this.role,
      required this.route});
  Driver_Model.fromJson(Map<String, Object?> json)
      : this(
          name: json['Driver_Name']! as String,
          email: json['Email']! as String,
          number: json['Phone_Number']! as String,
          photo: json['Photo']! as String,
          role: json['Role']! as String,
          route: json['Route']! as DocumentReference,
        );

  Map<String, Object?> toJson() {
    return {
      'Driver_Name': name,
      'Email': email,
      'Phone_Number': number,
      'Photo': photo,
      'Role': role,
      'Route': route
    };
  }
}
