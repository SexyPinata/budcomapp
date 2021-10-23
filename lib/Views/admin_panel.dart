// ignore_for_file: camel_case_types

import 'dart:ffi';

import 'package:budcomapp/Forms/route_add_form.dart';
import 'package:budcomapp/Forms/route_update_form.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:budcomapp/Models/route_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/driver_provider.dart';
import 'driver_entry.dart';

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
                MaterialPageRoute<void>(builder: (_) => DriverEntryScreen()));
          },

          //onPressed: () async {
          //  await _pushPage(context, const Driver_add_form());
          //},
          label: const Text('New Route'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.redAccent,
        ),
      )),
      const Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
    ];
    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.people), text: 'Tab1'),
      const Tab(icon: Icon(Icons.alt_route), text: 'Tab2'),
      const Tab(icon: Icon(Icons.forum), text: 'Tab3'),
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
                        _showMaterialDialog(RouteUpdateForm(
                            model: Route_Model.fromJson(data),
                            docId: document.id));
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