import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../Models/driver_model.dart';

String? _globalRoute;

class Driver_update_form extends StatefulWidget {
  Driver_Model model;
  String docId;
  Driver_update_form({Key? key, required this.model, required this.docId})
      : super(key: key);
  @override
  _Driver_Widget_formState createState() => _Driver_Widget_formState();
}

// ignore: camel_case_types
class _Driver_Widget_formState extends State<Driver_update_form> {
  _Driver_Widget_formState();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  late String fileName;
  File? imageFile;
  PickedFile? pickedImage;
  bool _load = false;
  Future<void> _picker(String inputSource) async {
    pickedImage;
    try {
      pickedImage = await ImagePicker().getImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 60);

      fileName = path.basename(pickedImage!.path);
      setState(() {
        imageFile = File(pickedImage!.path);
        _upload();
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> _upload() async {
    try {
      // Uploading the selected image with some custom meta data
      await storage.ref(fileName).putFile(imageFile!);
      await storage.ref(fileName).getDownloadURL().then((url) => {
            widget.model.photo = url,
          });
      // Refresh the UI
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var model = widget.model;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Name field
            TextFormField(
              initialValue: widget.model.name,
              onSaved: (value) async {
                widget.model.name = value!;
              },
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: model.email,
              onSaved: (value) async {
                widget.model.email = value!;
              },
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: widget.model.number,
              onSaved: (value) async {
                widget.model.number = value!;
              },
              decoration: const InputDecoration(
                hintText: 'Phone Number',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ), ////// Simple Dialog.
            ListTile(
              leading: imageFile == null
                  ? Image.network(model.photo)
                  : Image.file(
                      imageFile!,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        // Appropriate logging or analytics, e.g.
                        // myAnalytics.recordError(
                        //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                        //   exception,
                        //   stackTrace,
                        // );
                        return const Text('😢');
                      },
                    ),
              trailing: ElevatedButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                      title: const Text('Select Image'),
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: const Text('Gallery'),
                          onTap: () {
                            Navigator.pop(context, 'gallery');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: const Text('Camera'),
                          onTap: () {
                            Navigator.pop(context, 'camera');
                          },
                        ),
                      ],
                    ),
                  ).then((returnVal) async {
                    if (returnVal != null) {
                      await _picker(returnVal);
                      _load = true;
                    }
                  });
                },
                child: const Text('Photo'),
              ),
            ),
            GetRoutes(defaultRouteValue: widget.model.route),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      _formKey.currentState!.save();
                      await _upload();
                      String refString = '';
                      await FirebaseFirestore.instance
                          .collection('Routes')
                          .where('Name', isEqualTo: _globalRoute)
                          .get()
                          .then((querySnapshot) {
                        for (var result in querySnapshot.docs) {
                          refString = result.id;
                        }
                      });
                      widget.model.route = FirebaseFirestore.instance
                          .collection('Routes')
                          .doc(refString);
                      final docAddRef = FirebaseFirestore.instance
                          .collection('drivers')
                          .doc(widget.docId)
                          .withConverter<Driver_Model>(
                            fromFirestore: (snapshot, _) =>
                                Driver_Model.fromJson(snapshot.data()!),
                            toFirestore: (newDriver, _) => newDriver.toJson(),
                          );

                      await docAddRef.update(Driver_Model(
                              name: widget.model.name,
                              email: widget.model.email,
                              number: widget.model.number,
                              photo: widget.model.photo,
                              role: 'User',
                              route: widget.model.route)
                          .toJson());
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetRoutes extends StatefulWidget {
  DocumentReference defaultRouteValue;
  GetRoutes({Key? key, required this.defaultRouteValue}) : super(key: key);

  @override
  _Getroutes createState() => _Getroutes();
}

class _Getroutes extends State<GetRoutes> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Routes').snapshots();
  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Halmstad';
    widget.defaultRouteValue.get().then((var value) {
      Map<String, dynamic> val = value.data()! as Map<String, dynamic>;
      dropdownValue = val['Name'];
    });

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return DropdownButtonFormField<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          items: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> value =
                document.data()! as Map<String, dynamic>;
            return DropdownMenuItem<String>(
              value: value['Name'],
              child: Text(value['Name']),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            setState(() {
              dropdownValue = newValue!;
              _globalRoute = newValue;
            });
          },
        );
      },
    );
  }
}
