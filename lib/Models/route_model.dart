import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Route_Model {
  DocumentReference driver;
  Array list_of_aps;
  String name;
  DocumentReference temp_driver;

  Route_Model(
      {required this.driver,
      required this.list_of_aps,
      required this.name,
      required this.temp_driver});
  Route_Model.fromJson(Map<String, Object?> json)
      : this(
          driver: json['Driver']! as DocumentReference,
          list_of_aps: json['List_Of_Aps']! as Array,
          name: json['Name']! as String,
          temp_driver: json['TempDriver']! as DocumentReference,
        );

  Map<String, Object?> toJson() {
    return {
      'Driver': driver,
      'List_Of_Aps': list_of_aps,
      'Name': name,
      'TempDriver': temp_driver
    };
  }
}
