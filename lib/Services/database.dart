import 'package:budcomapp/Models/ap_assignment_model.dart';
import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:budcomapp/Models/route_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
//!! route ENRIES
  //Get Entries
  Stream<List<Route_Model>> getRoutes() {
    return _db.collection('Routes').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Route_Model.fromJson(doc.data()))
          .toList();
    });
  }

  //Upsert
  Future<void> setRoute(Route_Model entry) {
    var options = SetOptions(merge: true);

    return _db.collection('Routes').doc(entry.id).set(entry.toJson(), options);
  }

  //Delete
  Future<void> removeRoute(String entryId) {
    return _db.collection('Routes').doc(entryId).delete();
  }

//!! Assignment ENRIES
  //Get Entries
  Stream<List<ApAssignment>> getAssignments() {
    return _db.collection('drivers').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ApAssignment.fromMap(doc.data()))
          .toList();
    });
  }

  //Upsert
  Future<void> setAssignment(ApAssignment entry) {
    var options = SetOptions(merge: true);

    return _db.collection('drivers').doc(entry.id).set(entry.toMap(), options);
  }

  //Delete
  Future<void> removeAssignment(String entryId) {
    return _db.collection('drivers').doc(entryId).delete();
  }

//!! User ENRIES
  //Get Entries
  Stream<List<Driver_Model>> getDrivers() {
    return _db.collection('drivers').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Driver_Model.fromMap(doc.data()))
          .toList();
    });
  }

  //Upsert
  Future<void> setDriver(Driver_Model entry) {
    var options = SetOptions(merge: true);

    return _db.collection('drivers').doc(entry.id).set(entry.toMap(), options);
  }

  //Delete
  Future<void> removeDriver(String entryId) {
    return _db.collection('drivers').doc(entryId).delete();
  }

//!! AP ENRIES
  //Get Entries
  Stream<List<ApModel>> getAccessPoints() {
    return _db.collection('AccessPoints').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ApModel.fromMap(doc.data())).toList());
  }

  //Upsert
  Future<void> setAccessPoints(ApModel entry) {
    var options = SetOptions(merge: true);

    return _db
        .collection('AccessPoints')
        .doc(entry.id)
        .set(entry.toMap(), options);
  }

  //Delete
  Future<void> removeAccessPoints(String entryId) {
    return _db.collection('AccessPoints').doc(entryId).delete();
  }
}
