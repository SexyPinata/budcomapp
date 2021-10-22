import 'dart:ffi';

import 'package:budcomapp/Models/route_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

List<Object?>? _selectedDrivers;
List<Object?>? _selectedAps;

class RouteAddForm extends StatefulWidget {
  const RouteAddForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RouteAddFormState();
}

class RouteAddFormState extends State<RouteAddForm> {
  String? _name;
  String? _email;
  String? _password;
  String? _url;
  String? _phoneNumber;
  String? _calories;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 69,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _name = value;
      },
    );
  }

  Widget _builTempDriver() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Url'),
      keyboardType: TextInputType.url,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'URL is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _url = value;
      },
    );
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone number'),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _url = value;
      },
    );
  }

  Widget _buildCalories() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Calories'),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        int? calories = int.tryParse(value!);

        if (calories == null || calories <= 0) {
          return 'Calories must be greater than 0';
        }

        return null;
      },
      onSaved: (String? value) {
        _calories = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildName(),
            ApDropDown(),
            RaisedButton(
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                _formKey.currentState!.save();
                final docAddRef = FirebaseFirestore.instance
                    .collection('Routes')
                    .withConverter<Route_Model>(
                      fromFirestore: (snapshot, _) =>
                          Route_Model.fromJson(snapshot.data()!),
                      toFirestore: (newDriver, _) => newDriver.toJson(),
                    );
                // Add function here
                Navigator.pop(context);
                //Send to API
              },
            )
          ],
        ),
      ),
    );
  }
}

class ApDropDown extends StatefulWidget {
  const ApDropDown({Key? key}) : super(key: key);

  @override
  _ApDropDown createState() => _ApDropDown();
}

class _ApDropDown extends State<ApDropDown> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('AccessPoints').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return MultiSelectDialogField(
          buttonText: Text('APs'),
          buttonIcon: const Icon(Icons.arrow_downward),
          unselectedColor: Colors.white,
          selectedColor: Colors.redAccent,
          selectedItemsTextStyle: TextStyle(color: Colors.redAccent),
          //backgroundColor: Colors.white,
          itemsTextStyle: TextStyle(color: Colors.white),
          items: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> value =
                document.data()! as Map<String, dynamic>;
            return MultiSelectItem(
              value['Name'],
              value['Name'],
            );
          }).toList(),
          onConfirm: (labels) {
            _selectedAps = labels;
            print(labels);
          },
        );
      },
    );
  }
}
