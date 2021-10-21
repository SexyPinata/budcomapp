import 'dart:async';
import 'package:budcomapp/GetCurrentUser.dart';
import 'package:budcomapp/Models/ap_job_model.dart';
import 'package:budcomapp/admin_panel.dart';
import 'package:budcomapp/get_job_list.dart';
import 'package:budcomapp/signin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';

import '../main.dart';
import '../register_page.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

User? _user = auth.currentUser;

class _UserInformationState extends State<UserInformation> {
  final moviesRef =
      FirebaseFirestore.instance.collection('Jobs').withConverter<ApJob>(
            fromFirestore: (snapshot, _) => ApJob.fromJson(snapshot.data()!),
            toFirestore: (apjob, _) => apjob.toJson(),
          );

  final Stream<QuerySnapshot> _jobStream =
      FirebaseFirestore.instance.collection("Jobs").snapshots();

  @override
  void initState() {
    auth.userChanges().listen(
          (event) => setState(() => _user = event),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: GetJobList(driverEmail: _user!.email));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user = auth.currentUser;

  static List<Widget> _pages = <Widget>[
    Center(
      child: UserInformation(),
    ),
    Center(
      child: Icon(
        Icons.map,
        size: 150,
      ),
    ),
    Center(
      child: Icon(
        Icons.assignment_turned_in,
        size: 150,
      ),
    ),
  ];

  int _selectedIndex = 0; //New

  @override
  void initState() {
    auth.userChanges().listen(
          (event) => setState(() => user = event),
        );
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pushPage(BuildContext context, Widget page) async {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final User? user = auth.currentUser;
    var drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(user == null ? 'Not signed in' : '${user.displayName}'),
      accountEmail: Text(user == null ? '' : '${user.email}'),
      currentAccountPicture: CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Text(
            'Sign in',
          ),
          leading: const Icon(Icons.favorite),
          onTap: () {
            _pushPage(context, SignInPage());
          },
        ),
        ListTile(
          title: Text(
            'Registrer',
          ),
          leading: const Icon(Icons.comment),
          onTap: () async {
            await _pushPage(context, RegisterPage());
          },
        ),
        ListTile(
          title: Text(
            'Admin Panel',
          ),
          leading: const Icon(Icons.comment),
          onTap: () async {
            await _pushPage(context, AdminPanel());
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budcom UPS Manager'),
      ),
      body: IndexedStack(
        alignment: Alignment.bottomCenter,
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () async {
            final moviesRef = FirebaseFirestore.instance
                .collection('Routes/ZNQ0FUi9oQo9fPHshI8i/Jobs')
                .withConverter<ApJob>(
                  fromFirestore: (snapshot, _) =>
                      ApJob.fromJson(snapshot.data()!),
                  toFirestore: (apjob, _) => apjob.toJson(),
                );
            DocumentReference routeRef = FirebaseFirestore.instance
                .collection('Routes')
                .doc('ZlumZXvBJqZEDzgfnyPl');
            DocumentReference driverRef = FirebaseFirestore.instance
                .collection('Routes')
                .doc('3hIpTqRiL7Y85pMzhp6S');
            await moviesRef.add(
              ApJob(
                  route: routeRef,
                  ap_name: 'ap_name',
                  ap_address: 'ap_address',
                  receiver_name: 'receiver_name',
                  original_address: 'original_address',
                  dateTime: DateTime.now(),
                  driver: driverRef,
                  status: 'status',
                  tracking_number: 'tracking_number'),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(color: Colors.red[800], size: 40),
        selectedItemColor: Colors.red[800],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Finished Jobs',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}