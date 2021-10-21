import 'dart:async';
import 'package:budcomapp/GetCurrentUser.dart';
import 'package:budcomapp/Providers/accesspoint_provider.dart';
import 'package:budcomapp/Providers/driver_provider.dart';
import 'package:budcomapp/admin_panel.dart';
import 'package:budcomapp/get_job_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './register_page.dart';
import './signin_page.dart';
import 'GetUserRoute.dart';
import 'Models/ap_job_model.dart';
import 'package:flutter_signin_button/button_builder.dart';

import 'Views/home_page_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProvider(create: (_) => AccessPointProvider()),
      ],
      child: MyApp(),
    ),
  );
}

FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

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
      home: MyHomePage(
        title: 'Budcom',
      ),
    );
  }
}
