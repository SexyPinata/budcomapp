// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:developer';
import 'package:budcomapp/Models/ap_data_raw_model.dart';
import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Providers/accesspoint_provider.dart';
import 'package:budcomapp/Providers/assignment_provider.dart';
import 'package:budcomapp/Services/custom_excel_to_json.dart';
import 'package:budcomapp/Services/raw_accesspoint_data_processor.dart';
import 'package:excel_to_json/excel_to_json.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:budcomapp/Models/route_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../Providers/driver_provider.dart';
import 'driver_entry.dart';
import 'route_entry.dart';

class AdminPanel extends StatefulWidget {
  AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with AutomaticKeepAliveClientMixin {
  late DriverProvider entryProvider;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    //entryProvider = Provider.of<DriverProvider>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    entryProvider = Provider.of<DriverProvider>(context);
  }

  Widget _UserInformation(BuildContext context) {
    void _showMaterialDialog(Widget? content) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Material Dialog'),
              content: content,
            );
          });
    }

    return Center(
      child: StreamBuilder<List<Driver_Model>>(
        stream: entryProvider.entries,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
              children: snapshot.data!.map((driver) {
            return Card(
                child: ListTile(
              leading: Image.network(driver.photo),
              title: Text(driver.name),
              subtitle: Text(driver.email),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => DriverEntryScreen(entry: driver)));
              },
            ));
          }).toList());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int index = 1;
    bool _visable = false;
    void _showMaterialDialog(Widget? content) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: content,
            );
          });
    }

    final _kTabPages = <Widget>[
      Center(
          child: Scaffold(
        body: _UserInformation(context),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: '123',
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => DriverEntryScreen()));
          },

          //onPressed: () async {
          //  await _pushPage(context, const Driver_add_form());
          //},
          label: const Text('New Driver'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.redAccent,
        ),
      )),
      Center(
          child: Scaffold(
        body: RouteInfo(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => RouteEntryScreen()));
          },

          //onPressed: () async {
          //  await _pushPage(context, const Driver_add_form());
          //},
          label: const Text('New Route'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.redAccent,
        ),
      )),
      Center(child: RawAccessPointDataProcessor()),
    ];
    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.people), text: 'Drivers'),
      const Tab(icon: Icon(Icons.alt_route), text: 'Routes'),
      const Tab(icon: Icon(Icons.forum), text: 'Upload'),
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),

          // If `TabController controller` is not provided, then a
          // DefaultTabController ancestor must be provided instead.
          // Another way is to use a self-defined controller, c.f. "Bottom tab
          // bar" example.
          bottom: TabBar(
            tabs: _kTabs,
            onTap: (value) {
              setState(() {
                index = value;
                if (value != 0) _visable = false;
                if (value == 0) _visable = true;
                print(_visable);
                print(value);
              });
            },
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}

class RouteInfo extends StatefulWidget {
  const RouteInfo({Key? key}) : super(key: key);

  @override
  _RouteInfo createState() => _RouteInfo();
}

class _RouteInfo extends State<RouteInfo> with AutomaticKeepAliveClientMixin {
  final Stream<QuerySnapshot> _jobStream =
      FirebaseFirestore.instance.collection('Routes').snapshots();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    void _showMaterialDialog(Widget? content) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Material Dialog'),
              content: content,
            );
          });
    }

    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: _jobStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              List dara2 = data['List_Of_Aps'];
              return Card(
                child: ExpansionTile(
                    title: Text(data['Name']),
                    subtitle: Text(
                        'Number of APs assigned: ${data['List_Of_Aps'].length}'),
                    trailing: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent)),
                      child: const Text("Edit"),
                      onPressed: () {
                        Route_Model model = Route_Model.fromJson(data);
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => RouteEntryScreen(
                                  entry: model,
                                )));
                      },
                    ),
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        // Let the ListView know how many items it needs to build.
                        itemCount: dara2.length,
                        // Provide a builder function. This is where the magic happens.
                        // Convert each item into a widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          final item = dara2[index];

                          return Card(
                            child: ListTile(
                              title: Text(item),
                            ),
                          );
                        },
                      )
                    ]),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _pushPage(BuildContext context, Widget page) async {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class RawAccessPointDataProcessor extends StatefulWidget {
  RawAccessPointDataProcessor({Key? key}) : super(key: key);

  @override
  _RawAccessPointDataProcessorState createState() =>
      _RawAccessPointDataProcessorState();
}

class _RawAccessPointDataProcessorState
    extends State<RawAccessPointDataProcessor> {
  @override
  Widget build(BuildContext context) {
    final accessPointProvider =
        Provider.of<AccessPointProvider>(context, listen: false);

    final assignmentProvider =
        Provider.of<AssignmentProvider>(context, listen: false);
    List<ApModel> _memoryList;
    var _stream = accessPointProvider.entries;
    return Container(
      child: StreamBuilder<List<ApModel>>(
          stream: _stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<ApModel>> snapshot) {
            return ElevatedButton(
              child: Text("PRESS TO UPLOAD EXCEL AND CONVERT TO JSON"),
              onPressed: () {
                _memoryList = snapshot.data!;

                CustomExcelToJson().convert().then((onValue) {
                  Iterable li = json.decode(onValue!);
                  List<Aprawdatamodel> list = List<Aprawdatamodel>.from(
                      li.map((e) => Aprawdatamodel.fromMap(e)));
                  log(onValue.toString());
                  for (var item in list) {
                    bool isPresent = false;
                    for (var accessPoint in _memoryList) {
                      if (item.AP_Number == accessPoint.number) {
                        isPresent = true;
                        assignmentProvider.changeAddress = (item.Cnee_Address +
                            ' ' +
                            item.Cnee_City +
                            ' ' +
                            item.Cnee_PostalCode);
                        assignmentProvider.changeName = item.Cnee_Name;
                        assignmentProvider.changeAwb = item.Trackingnumber;
                        assignmentProvider.changePending = true;
                        log('Adding: ' +
                            item.Trackingnumber +
                            ' || To the Access Point ' +
                            accessPoint.name);
                        assignmentProvider.saveEntry(accessPoint);
                      }
                    }
                    if (!isPresent) {
                      var uuid = const Uuid();
                      log(item.AP_Name + ' was not found, adding');
                      var model = ApModel(
                          id: '123',
                          name: item.AP_Name,
                          city: item.AP_City,
                          street: item.AP_Address,
                          zip: item.AP_PostCode,
                          number: item.AP_Number);
                      _memoryList.add(model);
                      accessPointProvider.changeCity = item.AP_City;
                      accessPointProvider.changeName = item.AP_Name;
                      accessPointProvider.changeNumber = item.AP_Number;
                      accessPointProvider.changeStreet = item.AP_Address;
                      accessPointProvider.changeZip = item.AP_PostCode;
                      accessPointProvider.saveEntry();
                      accessPointProvider.loadAll(null);
                    }
                    if (isPresent) {}
                  }
                });
              },
            );
            /*   return TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.done,
              onSubmitted: (String value) {
                LineSplitter ls = const LineSplitter();
                List<String> lines = ls.convert(value);
                lines.removeWhere((element) => element.isEmpty);
                var partitions = partition(lines, 10);
                print("---Result---");
                for (var item in partitions) {}
                var xlsx = ExcelToJson();
              },
            );
*/
          }),
    );
  }
}
