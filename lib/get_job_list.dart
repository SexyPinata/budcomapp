// ignore: file_names
import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:budcomapp/Providers/accesspoint_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/route_model.dart';
import 'Providers/driver_provider.dart';

class GetJobList extends StatefulWidget {
  String? driverEmail;
  GetJobList({Key? key, required this.driverEmail}) : super(key: key);

  @override
  _GetJobListState createState() => _GetJobListState();
}

DocumentReference? routeDoc;

class _GetJobListState extends State<GetJobList> {
  late AccessPointProvider entryProvider;
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    entryProvider = Provider.of<AccessPointProvider>(context);
  }

// !! Get Current User + Route
  final driversRef = FirebaseFirestore.instance
      .collection('drivers')
      .withConverter<Driver_Model>(
          fromFirestore: (snapshot, _) =>
              Driver_Model.fromMap(snapshot.data()!),
          toFirestore: (driver, _) => driver.toMap());
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

  Widget _build(BuildContext context, Stream<QuerySnapshot> teststream) {
    return StreamBuilder<List<ApModel>>(
      stream: entryProvider.entries,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                title: Text(snapshot.data![index].name),
                subtitle: Text(snapshot.data![index].city),
              ));
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text('data');
  }
}
