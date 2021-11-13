// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:developer';
import 'package:budcomapp/Models/ap_assignment_model.dart';
import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Providers/accesspoint_provider.dart';
import 'package:budcomapp/Providers/assignment_provider.dart';
import 'package:budcomapp/Providers/driver_provider.dart';
import 'package:budcomapp/Providers/route_provider.dart';
import 'package:budcomapp/Views/admin_panel.dart';
import 'package:budcomapp/Views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

late AccessPointProvider accessPointProvider;
late RouteProvider routeProvider;
late AssignmentProvider assignmentProvider;

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  late AccessPointProvider accessPointProvider;
  late List<ApModel> apNames = [];
  late AssignmentProvider assignmentProvider;
  late DriverProvider driverProvider;
  late RouteProvider routeProvider;
  late List<Stream<List<ApAssignment>>> streams = [];
  late User _currentUser;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _currentUser = widget.user;
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    final accessPointProvider =
        Provider.of<AccessPointProvider>(context, listen: false);
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    final assignmentProvider =
        Provider.of<AssignmentProvider>(context, listen: false);

    driverProvider.changeEmail = _currentUser.email;
    driverProvider.entrie.then((value) {
      routeProvider.setId = value.routeId;
      routeProvider.entrie.then((value) {
        for (var item in List<ApModelMini>.from(
            value.list_of_aps.map((e) => ApModelMini.fromMap(e)))) {
          log(item.id);
          accessPointProvider.setId = item.id;

          accessPointProvider.entrie.then((value) {
            streams.add(assignmentProvider.entries(value));
            apNames.add(value);
            setState(() {});
            log(streams.toString());
          });
        }
      });
    });
    auth.userChanges().listen(
          (event) => setState(() => _currentUser = event!),
        );

    log('message');
    super.initState();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget res(BuildContext context) {
    assignmentProvider = Provider.of<AssignmentProvider>(context);
    routeProvider = Provider.of<RouteProvider>(context);
    return ListView.builder(
        shrinkWrap: false,
        itemCount: streams.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<ApAssignment>>(
              stream: streams[index],
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                log(snapshot.data!.map.toString());
                return Column(
                  children: [
                    Text(
                      apNames[index].name,
                      style: TextStyle(
                          color: Colors.red.shade800,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Column(
                        children: snapshot.data!.map((accessPoint) {
                      return Slidable(
                        dismissal: SlidableDismissal(
                          onDismissed: (actionType) {
                            _showSnackBar(actionType == SlideActionType.primary
                                ? 'Dismiss Archive'
                                : 'Dimiss Delete');
                            setState(() => assignmentProvider.removeEntry(
                                accessPoint.id, apNames[index]));
                          },
                          // Confirm on dismissal:
                          onWillDismiss: (actionType) {
                            return showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      actionType == SlideActionType.primary
                                          ? 'Archive'
                                          : 'Delete'),
                                  content: const Text('Confirm action?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            ) as FutureOr<bool>;
                          },
                          child: const SlidableDrawerDismissal(),
                        ),
                        key: Key(accessPoint.id),
                        actionPane: const SlidableDrawerActionPane(),
                        actions: [
                          IconSlideAction(
                            caption: 'Archive',
                            color: Colors.blue,
                            icon: Icons.archive,
                            onTap: () => _showSnackBar('Archive'),
                          ),
                        ], // 'Archive' action
                        secondaryActions: [
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => _showSnackBar('Delete'),
                          ),
                        ], // 'Delete' action
                        child: Card(
                            child: ListTile(
                          isThreeLine: true,
                          title: Text(
                            accessPoint.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(text: ' \n'),
                                TextSpan(
                                    text: accessPoint.address,
                                    style: TextStyle(
                                        color: Colors.cyanAccent.shade700)),
                                const TextSpan(text: ' \n\n'),
                                TextSpan(
                                    text: accessPoint.awb,
                                    style: const TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        decoration: TextDecoration.underline))
                              ],
                            ),
                          ),
                          onTap: () {},
                        )),
                      );
                    }).toList()),
                  ],
                );
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return res(context);
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title, required this.user})
      : super(key: key);

  final String title;
  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

late User _currentUser;

class _ProfilePageState extends State<ProfilePage> {
  bool _isSigningOut = false;
  static final List<Widget> _pages = <Widget>[
    Center(
      child: UserInformation(user: _currentUser),
    ),
    const Center(
      child: Icon(
        Icons.map,
        size: 150,
      ),
    ),
    const Center(
      child: Icon(
        Icons.assignment_turned_in,
        size: 150,
      ),
    ),
  ];

  int _selectedIndex = 0; //New

  @override
  void initState() {
    _currentUser = widget.user;
    auth.userChanges().listen(
          (event) => setState(() => _currentUser = event!),
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

    var drawerHeader = UserAccountsDrawerHeader(
      otherAccountsPicturesSize: const Size(85, 35),
      otherAccountsPictures: [
        SizedBox(height: 1.0),
        _isSigningOut
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await FirebaseAuth.instance.signOut();
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text('Sign out'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
      ],
      accountName: Text('${_currentUser.displayName}'),
      accountEmail: Text('${_currentUser.email}'),
      currentAccountPicture: const CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: const Text(
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
          child: const Icon(Icons.add),
          onPressed: () async {}),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20,
        backgroundColor: Colors.black26,
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
