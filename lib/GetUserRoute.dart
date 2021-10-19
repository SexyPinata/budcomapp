// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserRoute extends StatelessWidget {
  final DocumentReference documentRef;

  GetUserRoute(this.documentRef);

  @override
  Widget build(BuildContext context) {
    //CollectionReference users = FirebaseFirestore.instance.collection('Routes');
    return FutureBuilder<DocumentSnapshot>(
      future: documentRef.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(data['Name']);
        }

        return const Text("loading");
      },
    );
  }
}
