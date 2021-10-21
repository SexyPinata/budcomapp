// ignore: file_names
import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Models/route_model.dart';

class GetJobList extends StatefulWidget {
  String? driverEmail;
  GetJobList({Key? key, required this.driverEmail}) : super(key: key);

  @override
  _GetJobListState createState() => _GetJobListState();
}

DocumentReference? routeDoc;

class _GetJobListState extends State<GetJobList> {
// !! Get Current User + Route
  final driversRef = FirebaseFirestore.instance
      .collection('drivers')
      .withConverter<Driver_Model>(
          fromFirestore: (snapshot, _) =>
              Driver_Model.fromJson(snapshot.data()!),
          toFirestore: (driver, _) => driver.toJson());
  final routesRef = FirebaseFirestore.instance
      .collection('Routes')
      .withConverter<Route_Model>(
        fromFirestore: (snapshot, _) => Route_Model.fromJson(snapshot.data()!),
        toFirestore: (newDriver, _) => newDriver.toJson(),
      );

  final apRef = FirebaseFirestore.instance
      .collection('AccessPoint')
      .withConverter<ApModel>(
        fromFirestore: (snapshot, _) =>
            ApModel.fromJson(snapshot.data().toString()),
        toFirestore: (newDriver, _) => newDriver.toMap(),
      );

  Future<Widget> _getUserDoc() async {
    List<QueryDocumentSnapshot<Driver_Model>> drivers = await driversRef
        .where('Email', isEqualTo: widget.driverEmail)
        .get()
        .then((snapshot) => snapshot.docs);
    print(drivers.length);

    Route_Model route = await routesRef
        .doc(drivers.first.data().route.id)
        .get()
        .then((snapshot) => snapshot.data()!);
    print(route.list_of_aps);
    Stream<QuerySnapshot> _apJobStream = FirebaseFirestore.instance
        .collection('AccessPoint')
        .where("Name", whereIn: route.list_of_aps)
        .snapshots();
    var wid = _build(context, _apJobStream);
    return wid;
  }

  Widget _build(BuildContext context, Stream<QuerySnapshot> teststream) {
    return StreamBuilder<QuerySnapshot>(
      stream: teststream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Center(
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text(data['Jobs.Name']),
                  subtitle:
                      Text(data['Jobs.Address'] + ' \n' + data['Jobs.Awb']),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserDoc(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (!snapshot.hasData) return Text('No data');
        if (snapshot.hasError) return Text('Error');
        return snapshot.data!;
      },
    );
  }
}
