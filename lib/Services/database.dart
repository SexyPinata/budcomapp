import 'package:budcomapp/Models/ap_assignment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get Entries
  Stream<List<ApAssignment>> getEntries() {
    return _db.collection('entries').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ApAssignment.fromMap(doc.data())).toList());
  }

  //Upsert
  Future<void> setEntry(ApAssignment entry) {
    var options = SetOptions(merge: true);

    return _db.collection('entries').doc(entry.id).set(entry.toMap(), options);
  }

  //Delete
  Future<void> removeEntry(String entryId) {
    return _db.collection('entries').doc(entryId).delete();
  }
}
