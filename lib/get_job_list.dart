// ignore: file_names
// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:budcomapp/Providers/accesspoint_provider.dart';
import 'package:budcomapp/Providers/assignment_provider.dart';
import 'package:budcomapp/Providers/route_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/driver_provider.dart';

class GetJobList extends StatefulWidget {
  Driver_Model? driverModel;
  GetJobList({Key? key, required this.driverModel}) : super(key: key);

  @override
  _GetJobListState createState() => _GetJobListState();
}

DocumentReference? routeDoc;

class _GetJobListState extends State<GetJobList> {
  late AccessPointProvider accessPointProvider;
  late DriverProvider driverProvider;
  late RouteProvider routeProvider;
  late AssignmentProvider assignmentProvider;
  late DocumentReference ref;
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    accessPointProvider = Provider.of<AccessPointProvider>(context);
    driverProvider = Provider.of<DriverProvider>(context);
    routeProvider = Provider.of<RouteProvider>(context);
    assignmentProvider = Provider.of<AssignmentProvider>(context);

    super.didChangeDependencies();
  }

  Widget _loadSomedata() {
    try {
      routeProvider.setId = widget.driverModel!.routeId;
      var routeEntry = routeProvider.entrie;
      Future.delayed(Duration.zero, () async {
        routeProvider.loadAll(await routeEntry);
        for (var item in routeProvider.list_of_aps as List<ApModelMini>) {}
      });
    } catch (e) {}
    throw () {};
  }

  Widget _build(BuildContext context, Stream<dynamic> teststream) {
    return StreamBuilder<dynamic>(
      stream: teststream,
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
