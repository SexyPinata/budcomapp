// @dart=2.9
import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Services/database.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class AccessPointProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String _id;
  String _name;
  String _city;
  String _street;
  String _zip;
  String _number;
  var uuid = const Uuid();
  //Getters
  String get name => _name;
  String get city => _city;
  String get street => _street;
  String get zip => _zip;
  String get number => _number;

  Stream<List<ApModel>> get entries => firestoreService.getAccessPoints();
  Future<ApModel> get entrie => firestoreService.getAccessPoint(_id);
  //Setters

  set setId(String value) {
    _id = value;
  }

  set changeName(String name) {
    _name = name;
    notifyListeners();
  }

  set changeCity(String city) {
    _city = city;
    notifyListeners();
  }

  set changeStreet(String street) {
    _street = street;
    notifyListeners();
  }

  set changeZip(String zip) {
    _zip = zip;
    notifyListeners();
  }

  set changeNumber(String number) {
    _number = number;
    notifyListeners();
  }

  //Functions
  loadAll(ApModel entry) {
    if (entry != null) {
      _name = entry.name;
      _city = entry.city;
      _street = entry.street;
      _zip = entry.zip;
      _number = entry.number;
      _id = entry.id;
    } else {
      _name = null;
      _city = null;
      _street = null;
      _zip = null;
      _number = null;
      _id = null;
    }
  }

  saveEntry() {
    if (_id == null) {
      //Add
      var newEntry = ApModel(
          id: uuid.v1(),
          name: _name,
          city: _city,
          street: _street,
          number: _number,
          zip: _zip);
      print(newEntry.name);
      firestoreService.setAccessPoints(newEntry);
    } else {
      //Edit
      var updatedEntry = ApModel(
          id: _id,
          name: _name,
          city: _city,
          street: _street,
          zip: _zip,
          number: _number);
      firestoreService.setAccessPoints(updatedEntry);
    }
  }

  removeEntry(String entryId) {
    firestoreService.removeAccessPoints(entryId);
  }
}
