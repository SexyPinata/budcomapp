import 'package:budcomapp/Models/route_model.dart';
import 'package:budcomapp/Services/database.dart';
import 'package:flutter/cupertino.dart';

class RouteProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  List<Object?>? _list_of_aps;
  String? _name;
  String? _id;
//getters
  Stream<List<Route_Model>> get entries => firestoreService.getRoutes();
  List<Object?>? get list_of_aps => _list_of_aps;
  String? get name => _name;

//setters
  set changeList_of_aps(List<Object?>? newList_of_aps) {
    _list_of_aps = newList_of_aps;
    notifyListeners();
  }

  set changeName(String? newName) {
    _name = newName;
    notifyListeners();
  }

  //Functions
  loadAll(Route_Model entry) {
    if (entry != null) {
      _name = entry.name;
      _list_of_aps = entry.list_of_aps;
      _id = entry.id;
    } else {
      _name = null;
      _list_of_aps = null;
      _id = null;
    }
  }

  saveEntry() {
    if (_id == null) {
      //Add
      var newEntry =
          Route_Model(list_of_aps: _list_of_aps!, name: _name!, id: _id!);
      print(newEntry.name);
      firestoreService.setRoute(newEntry);
    } else {
      //Edit
      var updatedEntry =
          Route_Model(list_of_aps: _list_of_aps!, name: _name!, id: _id!);
      firestoreService.setRoute(updatedEntry);
    }
  }

  removeEntry(String entryId) {
    firestoreService.removeRoute(entryId);
  }
}
