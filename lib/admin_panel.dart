// ignore_for_file: camel_case_types

import 'dart:ffi';

import 'package:budcomapp/GetUserRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Forms/driver_add_form.dart';
import 'Models/driver_model.dart';
import 'Forms/driver_update_form.dart';

class admin_panel extends StatelessWidget {
  const admin_panel({Key? key}) : super(key: key);
  Future<void> _pushPage(BuildContext context, Widget page) async {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Center(child: UserInformation()),
      Center(child: RouteInfo()),
      const Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
    ];
    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.people), text: 'Tab1'),
      const Tab(icon: Icon(Icons.alt_route), text: 'Tab2'),
      const Tab(icon: Icon(Icons.forum), text: 'Tab3'),
    ];
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

    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('appbar title'),

          // If `TabController controller` is not provided, then a
          // DefaultTabController ancestor must be provided instead.
          // Another way is to use a self-defined controller, c.f. "Bottom tab
          // bar" example.
          bottom: TabBar(
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showMaterialDialog(const Driver_add_form());
          },
          //onPressed: () async {
          //  await _pushPage(context, const Driver_add_form());
          //},
          label: const Text('Add'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.redAccent,
        ),
      ),
    );
  }
}

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation>
    with AutomaticKeepAliveClientMixin {
  final Stream<QuerySnapshot> _jobStream =
      FirebaseFirestore.instance.collection('drivers').snapshots();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: _jobStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                  child: ListTile(
                leading: Image.network(data['Photo']),
                title: Text(data['Driver_Name']),
                subtitle: GetUserRoute(data['Route']),
                onLongPress: () {
                  _showMaterialDialog(Driver_update_form(
                    model: Driver_Model.fromJson(data),
                    docId: document.id,
                  ));
                },
              ));
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
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: _jobStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              List dara2 = data['List_Of_Aps'];
              print(dara2.first);
              return Card(
                child: ExpansionTile(
                    title: Text(data['Name']),
                    subtitle: Text('Trailing expansion arrow icon'),
                    trailing: ElevatedButton(
                      child: Text("Initialised Love"),
                      onPressed: () {},
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
