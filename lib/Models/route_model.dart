import 'package:budcomapp/Models/ap_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Route_Model {
  List<dynamic> list_of_aps;
  String name;
  String? id;

  Route_Model(
      {required this.list_of_aps, required this.name, required this.id});
  Route_Model.fromJson(Map<String, Object?> json)
      : this(
          list_of_aps: json['List_Of_Aps']! as List<dynamic>,
          name: json['Name']! as String,
          id: json['id']! as String,
        );

  Map<String, Object?> toJson() {
    return {'List_Of_Aps': list_of_aps, 'Name': name, 'id': id};
  }
}
