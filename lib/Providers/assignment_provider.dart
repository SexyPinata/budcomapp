// @dart=2.9
import 'package:budcomapp/Models/ap_assignment_model.dart';
import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Services/database.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class AssignmentProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String _id;
  String _name;
  String _address;
  String _awb;
  bool _pending;
  var uuid = const Uuid();
  //Getters
  String get name => _name;
  String get address => _address;
  String get awb => _awb;
  bool get pending => _pending;

  Stream<List<ApAssignment>> entries(ApModel model) =>
      firestoreService.getAssignments(model);

  //Setters
  set changeName(String name) {
    _name = name;
    notifyListeners();
  }

  set changeAddress(String address) {
    _address = address;
    notifyListeners();
  }

  set changeAwb(String awb) {
    _awb = awb;
    notifyListeners();
  }

  set changePending(bool pending) {
    _pending = pending;
    notifyListeners();
  }

  //Functions
  loadAll(ApAssignment entry) {
    if (entry = null) {
      _name = entry.name;
      _address = entry.address;
      _awb = entry.awb;
      _pending = entry.pending;
      _id = entry.id;
    } else {
      _name = null;
      _address = null;
      _awb = null;
      _pending = null;
      _id = null;
    }
  }

  saveEntry(ApModel accessPoint) {
    if (_id == null) {
      //Add
      var newEntry = ApAssignment(
          id: uuid.v1(),
          name: _name,
          address: _address,
          awb: _awb,
          pending: _pending);
      print(newEntry.name);
      firestoreService.setAssignment(newEntry, accessPoint);
    } else {
      //Edit
      var updatedEntry = ApAssignment(
          id: _id,
          name: _name,
          address: _address,
          awb: _awb,
          pending: _pending);
      print(updatedEntry.name);
      firestoreService.setAssignment(updatedEntry, accessPoint);
    }
  }

  removeEntry(String entryId, ApModel accessPoint) {
    firestoreService.removeAssignment(entryId, accessPoint);
  }
}
