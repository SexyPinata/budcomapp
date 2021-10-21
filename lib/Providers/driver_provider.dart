import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:budcomapp/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class DriverProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String? _id;
  String? _name;
  String? _email;
  String? _number;
  String? _photo;
  String? _role;
  DocumentReference? _route;
  //Getters
  String? get name => _name;
  String? get email => _email;
  String? get number => _number;
  String? get photo => _photo;
  String? get role => _role;
  DocumentReference? get route => _route;

  Stream<List<Driver_Model>> get entries => firestoreService.getDrivers();

  //Setters
  set changeName(String name) {
    _name = name;
    notifyListeners();
  }

  set changeEmail(String email) {
    _email = email;
    notifyListeners();
  }

  set changeNumber(String number) {
    _number = number;
    notifyListeners();
  }

  set changePhoto(String photo) {
    _photo = photo;
    notifyListeners();
  }

  set changeRole(String role) {
    _role = role;
    notifyListeners();
  }

  set ChangeRoute(DocumentReference route) {
    _route = route;
    notifyListeners();
  }

  //Functions
  loadAll(Driver_Model entry) {
    if (entry != null) {
      _name = entry.name;
      _email = entry.email;
      _number = entry.number;
      _photo = entry.photo;
      _role = entry.role;
      _id = entry.id;
      _route = entry.route;
    } else {
      _name = null;
      _email = null;
      _number = null;
      _photo = null;
      _role = null;
      _id = null;
      _route = null;
    }
  }

  saveEntry() {
    if (_id == null) {
      //Add
      var newEntry = Driver_Model(
          id: _id!,
          name: _name!,
          email: _email!,
          number: _number!,
          photo: _photo!,
          role: _role!,
          route: _route!);
      print(newEntry.name);
      firestoreService.setDriver(newEntry);
    } else {
      //Edit
      var updatedEntry = Driver_Model(
          id: _id!,
          name: _name!,
          email: _email!,
          number: _number!,
          photo: _photo!,
          role: _role!,
          route: _route!);
      print(updatedEntry.name);
      firestoreService.setDriver(updatedEntry);
    }
  }

  removeEntry(String entryId) {
    firestoreService.removeDriver(entryId);
  }
}
