import 'package:cloud_firestore/cloud_firestore.dart';

class ApJob {
  ApJob(
      {required this.route,
      required this.ap_name,
      required this.ap_address,
      required this.receiver_name,
      required this.original_address,
      required this.dateTime,
      required this.driver,
      required this.status,
      required this.tracking_number});

  ApJob.fromJson(Map<String, Object?> json)
      : this(
          route: json['route']! as DocumentReference,
          ap_name: json['Ap_Namn']! as String,
          ap_address: json['Ap_Address']! as String,
          receiver_name: json['Receiver_Name']! as String,
          original_address: json['Original_Address']! as String,
          dateTime: json['Date']! as DateTime,
          driver: json['Driver']! as DocumentReference,
          status: json['Status']! as String,
          tracking_number: json['Tracking_Number']! as String,
        );

  final String ap_address;
  final String ap_name;
  final DateTime dateTime;
  final DocumentReference driver;
  final String original_address;
  final String receiver_name;
  final DocumentReference route;
  final String status;
  final String tracking_number;

  Map<String, Object?> toJson() {
    return {
      'Route': route,
      'Ap_Name': ap_name,
      'Ap_Address': ap_address,
      'Receiver_Name': receiver_name,
      'Original_Address': original_address,
      'Date': dateTime,
      'Driver': driver,
      'Status': status,
      'Tracking_Number': tracking_number
    };
  }
}
