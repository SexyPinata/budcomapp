// @dart=2.9
import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:budcomapp/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class DriverProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String _id;
  String _name;
  String _email;
  String _number;
  String _photo;
  String _role;
  String _routeId;
  String _route;
  var uuid = const Uuid();
  //Getters
  String get name => _name;
  String get email => _email;
  String get number => _number;
  String get photo => _photo;
  String get role => _role;
  String get route => _route;
  String get routeId => _routeId;

  Stream<List<Driver_Model>> get entries => firestoreService.getDrivers();
  Future<Driver_Model> get entrie => firestoreService.getDriver(_email);
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

  set ChangeRoute(String route) {
    _route = route;
    notifyListeners();
  }

  set ChangeRouteId(String routeId) {
    _routeId = routeId;
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
      _routeId = entry.routeId;
    } else {
      _name = null;
      _email = null;
      _number = null;
      _photo = null;
      _role = null;
      _id = null;
      _route = null;
      _routeId = null;
    }
  }

  saveEntry() {
    if (_id == null) {
      //Add
      var newEntry = Driver_Model(
          id: uuid.v1(),
          name: _name,
          email: _email,
          number: _number,
          photo: _photo,
          role: _role,
          route: _route,
          routeId: _routeId);
      print(newEntry.name);
      firestoreService.setDriver(newEntry);
    } else {
      //Edit
      var updatedEntry = Driver_Model(
          id: _id,
          name: _name,
          email: _email,
          number: _number,
          photo: _photo,
          role: _role,
          route: _route,
          routeId: _routeId);
      print(updatedEntry.name);
      firestoreService.setDriver(updatedEntry);
    }
  }

  removeEntry(String entryId) {
    firestoreService.removeDriver(entryId);
  }
}
