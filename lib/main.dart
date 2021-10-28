// @dart=2.9
import 'dart:async';
import 'package:budcomapp/Providers/accesspoint_provider.dart';
import 'package:budcomapp/Providers/assignment_provider.dart';
import 'package:budcomapp/Providers/driver_provider.dart';
import 'package:budcomapp/Providers/route_provider.dart';
import 'package:budcomapp/Views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Views/home_page_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProvider(create: (_) => AccessPointProvider()),
        ChangeNotifierProvider(create: (_) => RouteProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budcom UPS Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorScheme: const ColorScheme.dark(secondary: Colors.redAccent),
        primarySwatch: Colors.red,
      ),
      home: LoginPage(),
    );
  }
}
