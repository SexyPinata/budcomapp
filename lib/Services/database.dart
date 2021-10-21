import 'package:budcomapp/Models/ap_assignment_model.dart';
import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
